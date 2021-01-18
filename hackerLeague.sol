// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "https://github.com/chunqizhi/openzeppelin-contracts/blob/zcq/contracts/token/ERC20/ERC20.sol";
import "https://github.com/chunqizhi/hackerLeague/blob/main/hackerLeagueOracle.sol";

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
    HackerLeagueOracle private oracleHEToDai = HackerLeagueOracle(0x8F287DB69B3c08Dc42187FF2bC566862B9f13Ee6);
    // 获取 DAI 与 USDT 的交易对
    HackerLeagueOracle private oracleDaiToUsdt = HackerLeagueOracle(0xda96148fb87A62a6E8A95b946Cd92610ECf6A370);

    // DAI erc20 代币地址
    address private daiTokenAddress = 0xAde61F17de209Eb1e94368641f28E4a866DD5e59;

    // HE1 erc20 代币地址
    address private he1TokenAddress = 0x3ff4965Ab59b31eb0FaA3dfdB10A6d59165d6980;

    // HE3 erc20 代币地址
    address private he3TokenAddress = 0xe273b0b1C81CEFfC16C4026BdEe82aB736fFf273;

    // 用户算力购买情况事件
    event LogBuyHashRate(address indexed owner, address indexed superior, uint hashRate);

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
     * 用户使用 he1 购买算力
     * 需要该用户拥有 HE-1 代币
     *
     * Requirements:
     *
     * - `_tokenAmount` 使用 token 数量购买算力
     * - `_superior` 直接上级
     */
    function buyHashRateWithHE1(uint256 _tokenAmount, address _superior) public {
        _buyHashRate(ERC20(he1TokenAddress), _tokenAmount, _tokenAmount, _superior);
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
        // 从预言机获取 HE3 与 DAI的交易对价格
        uint dai = oracleHEToDai.consult(he3TokenAddress, _tokenAmount);
        // 从预言机获取 DAI 与 usdt 的交易对价格
        uint usdt = oracleDaiToUsdt.consult(daiTokenAddress, dai);

        _buyHashRate(ERC20(he3TokenAddress), _tokenAmount, usdt, _superior);
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
    function _buyHashRate(ERC20 _tokenAddress,uint _tokenAmount, uint256 _usdtAmount, address _superior) internal {

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


        // 10 USDT = 1T
        // 计算当前能买多少算力
        uint hashRate = _usdtAmount / 10;

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
        emit LogBuyHashRate(msg.sender, _superior, hashRate);
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