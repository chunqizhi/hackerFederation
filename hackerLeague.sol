// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

pragma experimental ABIEncoderV2;

import "https://github.com/chunqizhi/openzeppelin-contracts/blob/zcq/contracts/token/ERC20/ERC20.sol";
import "https://github.com/chunqizhi/hackerLeague/blob/main/hackerLeagueOracle.sol";




//用户推荐关系、算力购买、HE-3 代币释放和用户收益提取记录为去中心化
contract HackerLeague {
    address public owner;
    // 用户
    struct user {
        address superior;
        uint256 hashRate;
        bool isUser;
    }
    mapping(address => user) public users;

    // 预言机地址
    // 获取 HE3/HE1 与 DAI 的交易对
    HackerLeagueOracle private oracleHEToDai = HackerLeagueOracle(0x296476F75251dac93D777f190A3cdA5fea6aEcd2);
    // 获取 DAI 与 USDT 的交易对
    HackerLeagueOracle private oracleDaiToUsdt = HackerLeagueOracle(0xc714f612A2c113Cb8Ebaa2ebe064fd1D6C3B9CC0);

    // DAI erc20 代币地址
    address private daiTokenAddress = 0x750fb8d4a158eA723f4C846a39602eA222261B54;

    // HE1 erc20 代币地址
    address private he1TokenAddress = 0x750fb8d4a158eA723f4C846a39602eA222261B54;

    // HE3 erc20 代币地址
    address private he3TokenAddress = 0x750fb8d4a158eA723f4C846a39602eA222261B54;

    // 用户算力购买情况事件
    event LogBuyHashRate(address indexed owner, uint indexed hashRate, address indexed superior);
    // 用户收益提取记录事件
    event LogWithdraw(address indexed owner, uint indexed reward);

    constructor() public {
        //
        owner = msg.sender;
    }

    // 函数修改器，只有 owner 满足条件
    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }

    /**
     * 用户购买算力
     * 需要该用户拥有 HE-1 或者 HE-3 代币
     *
     * Requirements:
     *
     * - `_token` HE-1 或者 HE-3 的合约地址
     * - `_tokenAmount` 使用 token 数量购买算力
     * - `_superior` 直接上级
     */
    function buyHashRate(ERC20 _tokenAddress, uint256 _tokenAmount, address _superior) public {
        // _tokenAddress = he1 或者 he3
        require(he1TokenAddress == address(_tokenAddress) || he3TokenAddress == address(_tokenAddress), "Should be HE1 or HE3 ERC20 token address");

        // 判断上级是否是 user 或 owner，如果都不是，抛出错误
        if (!(users[_superior].isUser || _superior == owner)) {
            require(users[_superior].isUser, "Superior should be a user or owner");
        }

        // 是否拥有 _amount 数量的 _token 代币
        require(
            _tokenAddress.allowance(msg.sender, address(this)) >= _tokenAmount,
            "Token allowance too low"
        );
        bool sent = _tokenAddress.transferFrom(msg.sender, owner, _tokenAmount);
        require(sent, "Token transfer failed");

        uint usdt = _tokenAmount;

        // 如果是 he3，则需要通过预言机获取对应的 usdt 价格
        if (address(_tokenAddress) == he3TokenAddress) {
            // 从预言机获取 HE3/HE1 与 DAI的交易对价格
            uint dai = oracleHEToDai.consult(address(_tokenAddress),_tokenAmount);
            // 从预言机获取 DAI 与 usdt 的交易对价格
            usdt = oracleDaiToUsdt.consult(daiTokenAddress, dai);
        }

        // 10 USDT = 1T
        // 计算当前能买多少算力
        uint hashRate = usdt / 10;

        // 单次购买不的少于 1T 算力
        require(hashRate >= 1, "Need buy 1T least");

        if (users[msg.sender].isUser) {
            // 再次购买，不改变直接上级，直接更新算力
            users[msg.sender].hashRate += hashRate;
        } else {
            // 第一次购买算力，更新上级和算力
            users[msg.sender].superior = _superior;
            users[msg.sender].hashRate = hashRate;
            users[msg.sender].isUser = true;
        }

        // 触发事件
        emit LogBuyHashRate(msg.sender, hashRate, _superior);
    }

    /**
     * 官方触发用户的提币申请
     *
     * Requirements:
     *
     * - `_token` HE-3 的合约地址
     * - `_userAddress` 用户地址
     * - `_amount` HE-3 token 数量（手续费需用户支付，后端已经扣除等价的 HE-3）
     */
    function withdraw(ERC20 _tokenAddress, address _userAddress, uint _amount) public onlyOwner {
        // 只能 owner 来调用
        // 保证 owner 地址允许该合约地址可以花费的 HE-3 token 大于等于 _amount
        require(
            _tokenAddress.allowance(msg.sender, address(this)) >= _amount,
            "Token allowance too low"
        );

        bool sent = _tokenAddress.transferFrom(msg.sender, _userAddress, _amount);
        require(sent, "Token transfer failed");

        // 触发事件
        emit LogWithdraw(_userAddress, _amount);
    }

    /**
      * 获取用户信息
      *
      * Requirements:
      *
      * - `_userAddress` 用户地址
      */
    // 需要引入下面才能支持返回 user
    // pragma experimental ABIEncoderV2
    function userInfo(address _userAddress) public view returns (user memory) {
        return users[_userAddress];
    }

    /**
     * 获取用户上级
     *
     * Requirements:
     *
     * - `_userAddress` 用户地址
     */
    function userSuperior(address _userAddress) public view returns (address) {
        return users[_userAddress].superior;
    }

    /**
     * 获取用户算力
     *
     * Requirements:
     *
     * - `_userAddress` 用户地址
     */
    function userHashRate(address _userAddress) public view returns (uint) {
        return users[_userAddress].hashRate;
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
}