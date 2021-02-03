// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

import 'https://github.com/qq79324055/openzeppelin-contracts/blob/release-v3.0.0/contracts/math/SafeMath.sol';

interface Token {
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract HackerFederation {
    using SafeMath for uint256;

    // 算力小数点位数
    uint256 public constant hashRateDecimals = 5;
    // 每 10 usdt = 1 T
    uint256 public constant hashRatePerUsdt = 10;
    //
    address public owner;
    // 顶点地址
    address public rootAddress;
    // 销毁地址
    address public burnAddress;

    // dai 对 he3 币对 address
    address public daiToHe3Address;

    // Dai erc20 代币地址
    address public daiTokenAddress;
    Token tokenDai;
    // HE3 erc20 代币地址
    address public he3TokenAddress;
    Token tokenHe3;

    // HE1 erc20 代币地址
    address public he1TokenAddress;

    // 用户信息
    struct User {
        address superior;
        uint256 hashRate;
        bool isUser;
    }
    // 保存用户信息对应关系
    mapping(address => User) public users;

    // 用户算力购买情况事件
    event LogBuyHashRate(address indexed owner, address indexed superior, uint256 hashRate);

    constructor(address _rootAddress, address _burnAddress, address _daiToHe3Address, address _daiTokenAddress, address _he3TokenAddress, address _he1TokenAddress) public {
        //
        owner = msg.sender;
        //
        rootAddress = _rootAddress;
        //
        burnAddress = _burnAddress;
        //
        daiToHe3Address = _daiToHe3Address;

        //
        daiTokenAddress = _daiTokenAddress;
        tokenDai = Token(daiTokenAddress);
        //
        he3TokenAddress = _he3TokenAddress;
        tokenHe3 = Token(he3TokenAddress);
        //
        he1TokenAddress = _he1TokenAddress;
    }

    // 函数修改器，只有 owner 满足条件
    modifier onlyOwner() {
        require(msg.sender == owner, "This function is restricted to the owner");
        _;
    }

    //
    modifier notAddress0(address newAddress) {
        require(newAddress != address(0), "Address should not be address(0)");
        _;
    }

    /**
     * 用户使用 he1 购买算力
     * 需要该用户拥有 HE-1 代币
     *
     * Requirements:
     *
     * - `_tokenAmount` 使用 token 数量购买算力
     * - `_superior` 直接上级
     */
    function buyHashRateWithHE1(uint256 _tokenAmount, address _superior) public {
        //
        _buyHashRate(he1TokenAddress, _tokenAmount, _tokenAmount.div(10**12), _superior);
    }

    /**
     * 用户使用 he3 购买算力
     * 需要该用户拥有 HE-3 代币
     *
     * Requirements:
     *
     * - `_tokenAmount` 使用 token 数量购买算力
     * - `_superior` 直接上级
     */
    function buyHashRateWithHE3(uint256 _tokenAmount, address _superior) public {
        // totalDai 含有 18 位小数，但是目前 usdt 在主网上是 6 位小数
        uint256 totalDai = getHe3ToDai(_tokenAmount);
        //
        _buyHashRate(he3TokenAddress, _tokenAmount, totalDai.div(10**12), _superior);
    }

    /**
     * 用户购买算力
     * 需要该用户拥有 HE-1 或者 HE-3 代币
     *
     * Requirements:
     *
     * - `_token` HE-1 或者 HE-3 的合约地址
     * - `_tokenAmount` 使用 token 数量购买算力
     * - `_usdtAmount` _tokenAmount 与 usdt 的价格
     * - `_superior` 直接上级
     */
    function _buyHashRate(address _tokenAddress,uint256 _tokenAmount, uint256 _usdtAmount, address _superior) internal {
        // 判断上级是否是 user 或 rootAddress，如果都不是，抛出错误
        require(users[_superior].isUser || _superior == rootAddress, "Superior should be a user or rootAddress");

        // 销毁对应的代币
        bool sent = Token(_tokenAddress).transferFrom(msg.sender, burnAddress, _tokenAmount);
        require(sent, "Token transfer failed");

        // 10 000000 USDT = 1 00000T, 10 为小数点
        require(_usdtAmount >= 10000000, "Usdt should be great than or equal 10");
        // 计算当前能买多少算力
        uint256 hashRate = _usdtAmount.div(10).div(hashRatePerUsdt);
        //
        if (users[msg.sender].isUser) {
            // 再次购买，不改变直接上级，直接更新算力
            users[msg.sender].hashRate = users[msg.sender].hashRate.add(hashRate);
        } else {
            // 第一次购买算力，更新用户信息
            users[msg.sender].superior = _superior;
            users[msg.sender].hashRate = hashRate;
            users[msg.sender].isUser = true;
        }
        // 触发购买算力事件
        emit LogBuyHashRate(msg.sender, _superior, hashRate);
    }

    // 更新管理员地址
    function updateOwnerAddress(address _newOwnerAddress) public onlyOwner notAddress0(_newOwnerAddress) {
        owner = _newOwnerAddress;
    }

    // 更新销毁地址
    function updateBurnAddress(address _newBurnAddress) public onlyOwner notAddress0(_newBurnAddress){
        burnAddress = _newBurnAddress;
    }

    // 更新 he3 合约地址
    function updateHe3TokenAddress(address _he3TokenAddress) public onlyOwner notAddress0(_he3TokenAddress){
        he3TokenAddress = _he3TokenAddress;
        tokenHe3 = Token(he3TokenAddress);
    }

    // 更新 he1 合约地址
    function updateHe1TokenAddress(address _he1TokenAddress) public onlyOwner notAddress0(_he1TokenAddress){
        he1TokenAddress = _he1TokenAddress;
    }

    // 更新 dai 合约地址
    function updateDaiToHe3AddressAddress(address _daiToHe3Address) public onlyOwner notAddress0(_daiToHe3Address){
        daiToHe3Address = _daiToHe3Address;
    }

    // 更新 he3 对 dai 币对合约地址
    function updateDaiTokenAddress(address _daiTokenAddress) public onlyOwner notAddress0(_daiTokenAddress){
        daiTokenAddress = _daiTokenAddress;
        tokenDai = Token(daiTokenAddress);
    }

    /**
     * 判断该地址是否为用户
     *
     * Requirements:
     *
     * - `_userAddress` 用户地址
     */
    function isUser(address _userAddress) public view returns (bool) {
        return users[_userAddress].isUser;
    }

    // 获取 1 个 he3 兑换多少个 dai
    function getDaiPerHe3() public view returns (uint256) {
        return getHe3ToDai(10**18);
    }

    // 获取 _he3Amount 个 he3 兑换多少个 dai
    function getHe3ToDai(uint256 _he3Amount) internal view returns (uint256) {
        return tokenDai.balanceOf(daiToHe3Address).mul(_he3Amount).div(tokenHe3.balanceOf(daiToHe3Address));
    }
}