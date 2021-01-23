// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "https://github.com/chunqizhi/openzeppelin-contracts/blob/zcq/contracts/token/ERC20/ERC20.sol";

contract HE3 is ERC20 {
    // 当前已经挖出总量
    uint256 public _totalMintBalance;
    // 管理员
    address public _owner;
    // 销毁地址
    address public _burnAddress = 0xC206F4CC6ef3C7bD1c3aade977f0A28ac42F3E37;
    // 手续费接收地址
    address public _rewardAddress = 0xC5EA2EA8F6428Dc2dBf967E5d30F34E25D7ef5B8;

    /**
     * 构造函数
     *
     * Requirements:
     *
     * - `initialSupply` 代币发行总量
     * - `name` 代币名称
     * - `symbol` 代币符号
     * - `ownerAddress` 初始流通代币接收地址
     * - `ownerToken` 初始流通代币数量
     */
    constructor(uint256 initialSupply, string memory name, string memory symbol, address ownerAddress, uint256 ownerToken) ERC20(name, symbol) public {
        // 初始流通量不能超过发行总量
        require(ownerToken <= initialSupply, "ownerToken should less than or equal initialSupply");
        // 部署地址赋值 owner 变量
        _owner = msg.sender;
        // 发行总量
        _totalSupply = _totalSupply.add(initialSupply * 10 ** uint(_decimals));
        // 预挖矿
        _balances[ownerAddress] = _balances[ownerAddress].add(ownerToken * 10 ** uint(_decimals));
        // 当前已经挖出总量
        _totalMintBalance = _totalMintBalance.add(ownerToken * 10 ** uint(_decimals));
        // 挖矿
        emit Transfer(address(0), ownerAddress, ownerToken * 10 ** uint(_decimals));
    }

    // 函数修改器，只有 owner 满足条件
    modifier onlyOwner() {
        require(msg.sender == _owner, "only owner");
        _;
    }

    // 更改管理员
    function setOwner(address newOwnerAddress) public onlyOwner {
        _owner = newOwnerAddress;
    }

    // 更改销毁地址
    function setBurnAddress(address newBurnAddress) public onlyOwner {
        _burnAddress = newBurnAddress;
    }

    // 更改接收手续费地址
    function setRewardAddress(address newRewardAddress) public onlyOwner {
        _rewardAddress = newRewardAddress;
    }

    /**
     * 挖矿
     * 只能管理员调用
     *
     * Requirements:
     *
     *  `userAddress` 用户地址
     * - `userToken` HE-3 token 数量
     *  `rewardAddress` 收取手续费地址
     * - `rewardToken` HE-3 token 数量
     */
    function mint(address userAddress, uint256 userToken, uint256 rewardToken) public onlyOwner{
        require(userAddress != address(0), "ERC20: mint to the zero address");
        // 当前已经挖出总量增加对应值
        _totalMintBalance = _totalMintBalance.add(userToken + rewardToken);
        // 当前已经挖出总量不能超过发行总量
        require(_totalMintBalance <= totalSupply(), "_totalMintBalance should be less than or equal totalSupply");
        // 手续费地址挖矿
        _balances[_rewardAddress] = _balances[_rewardAddress].add(rewardToken);
        // 挖矿
        emit Transfer(address(0), _rewardAddress, rewardToken);
        // 用户地址提现
        _balances[userAddress] = _balances[userAddress].add(userToken);
        // 挖矿
        emit Transfer(address(0), userAddress, userToken);
    }

    /**
     * 销毁代币
     * 前提：持有 he3 代币
     *
     * Requirements:
     *
     * - `amount` HE-3 token 数量
     */
    function burn(uint256 amount) public {
        // 销毁，基类以支持可以转账给 address(0) 地址
        _transfer(msg.sender, _burnAddress, amount);
    }

    /**
     * 管理员直接销毁代币
     * 只能管理员调用
     *
     * Requirements:
     *
     * - `_amount` HE-3 token 数量
     */
    function burnFromOwner(uint256 amount) public onlyOwner {
        // 当前已经挖出总量增加对应值
        _totalMintBalance = _totalMintBalance.add(amount);
        // 当前已经挖出总量不能超过发行总量
        require(_totalMintBalance <= totalSupply(), "_totalMintBalance should be less than or equal totalSupply");
        // 销毁地址增加对应数量
        _balances[_burnAddress] = _balances[_burnAddress].add(amount);
        // 销毁代币
        emit Transfer(address(0), _burnAddress, amount);
    }
}