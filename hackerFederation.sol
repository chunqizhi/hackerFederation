// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "https://github.com/chunqizhi/openzeppelin-contracts/blob/zcq/contracts/token/ERC20/ERC20.sol";
import "https://github.com/chunqizhi/hackerLeague/blob/main/hackerFederationOracle.sol";

contract HackerFederation {
    uint public hashRatePerUsdt = 10;
    address public owner;

    address public _burnAddress = 0xC206F4CC6ef3C7bD1c3aade977f0A28ac42F3E37;

    uint public HashRateDecimals = 5;

    uint public constant PERIOD = 1 minutes;

    uint public UsdtPerHE3;
    // 用户
    struct user {
        address superior;
        uint256 hashRate;
        bool isUser;
    }
    mapping(address => user) public users;

    // 预言机地址
    // 获取 HE3/HE1 与 DAI 的交易对
    HackerFederationOracle private oracleHE3ToDai = HackerFederationOracle(0x9972B152Fff6e43C4eFe82C8F01a5404446dad9c);
    // 获取 DAI 与 USDT 的交易对
    HackerFederationOracle private oracleDaiToUsdt = HackerFederationOracle(0x2d9E0b536231151fbf27e1899b2102d075ABf59F);

    uint  public OracleHE3ToDaiBlockTimestampLast = oracleHE3ToDai.blockTimestampLast();
    uint  public OracleDaiToUsdtBlockTimestampLast = oracleDaiToUsdt.blockTimestampLast();

    // DAI erc20 代币地址
    address private daiTokenAddress = 0xBB4061a623ad68983bd0FdDE70a096Ea659aBEaa;

    // HE1 erc20 代币地址
    address private he1TokenAddress = 0x37153D7cD83baEfCC5DAFE7E91E755B4B33D2C40;

    // HE3 erc20 代币地址
    address private he3TokenAddress = 0xa00be484dF1A4914B20D1042A67990584b8Df57D;

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

    // 更改销毁地址
    function setBurnAddress(address newBurnAddress) public onlyOwner {
        _burnAddress = newBurnAddress;
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
        // 如果过了 24 hours，就触发预言机合约
        uint timeElapsed1 = block.timestamp - OracleHE3ToDaiBlockTimestampLast;
        if (timeElapsed1 > PERIOD) {
            oracleHE3ToDai.update();
            OracleHE3ToDaiBlockTimestampLast = oracleHE3ToDai.blockTimestampLast();
        }
        uint timeElapsed2 = block.timestamp - OracleDaiToUsdtBlockTimestampLast;
        if (timeElapsed2 > PERIOD) {
            oracleDaiToUsdt.update();
            OracleDaiToUsdtBlockTimestampLast = oracleDaiToUsdt.blockTimestampLast();
        }

        // 从预言机获取 HE3 与 DAI的交易对价格
        uint dai = oracleHE3ToDai.consult(he3TokenAddress, _tokenAmount);
        // 从预言机获取 DAI 与 usdt 的交易对价格
        uint usdt = oracleDaiToUsdt.consult(daiTokenAddress, dai);

        if (timeElapsed1 > PERIOD || timeElapsed2 > PERIOD) {
            UsdtPerHE3 =  usdt;
        }

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

        bool sent = _tokenAddress.transferFrom(msg.sender, _burnAddress, _tokenAmount);
        require(sent, "Token transfer failed");


        // 10 000000 USDT = 1 00000T
        // 计算当前能买多少算力
        uint hashRate = _usdtAmount / hashRatePerUsdt;

        // 单次购买不的少于 1T 算力
        require(hashRate >= 1 * 10 ** HashRateDecimals, "Need buy 1T at least");

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