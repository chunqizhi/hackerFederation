// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "https://github.com/chunqizhi/openzeppelin-contracts/blob/zcq/contracts/token/ERC20/ERC20.sol";

contract HE3 is ERC20 {
    // 当前已经挖出总量
    uint256 public _totalMintBalance;
    // 管理员
    address public owner;

    address public _burnAddress = 0xC206F4CC6ef3C7bD1c3aade977f0A28ac42F3E37;

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
        // Mint 100 tokens to msg.sender
        // Similar to how
        // 1 token = 1 * (100 ** decimals)
        require(ownerToken <= initialSupply, "ownerToken should less than or equal initialSupply");
        owner = msg.sender;
        // 预挖矿
        _balances[ownerAddress] = _balances[ownerAddress].add(ownerToken * 10 ** uint(_decimals));
        // 发行总量
        _totalSupply = _totalSupply.add(initialSupply * 10 ** uint(_decimals));
        // 当前未挖出重量
        _totalMintBalance = _totalMintBalance.add(ownerToken * 10 ** uint(_decimals));

        emit Transfer(address(0), address(0), _totalSupply);
        emit Transfer(address(0), address(0), _totalMintBalance);
        emit Transfer(address(0), ownerAddress, ownerToken * 10 ** uint(_decimals));

    }

    // 函数修改器，只有 owner 满足条件
    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }

    // 更改管理员
    function setOwner(address newOwnerAddress) public onlyOwner {
        owner = newOwnerAddress;
    }

    // 更改销毁地址
    function setBurnAddress(address newBurnAddress) public onlyOwner {
        _burnAddress = newBurnAddress;
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
    function mint(address userAddress, uint256 userToken, address rewardAddress, uint256 rewardToken) public onlyOwner{
        require(userAddress != address(0), "ERC20: mint to the zero address");

        uint256 token = userToken + rewardToken;
        // 挖矿少于未挖出的数量
        require(token <= totalSupply() - _totalMintBalance, "Minted to many.");
        //
        _totalMintBalance = _totalMintBalance.add(token);
        require(_totalMintBalance <= totalSupply(), "_totalMintBalance should be less than or equal totalSupply");
        //
        _beforeTokenTransfer(address(0), rewardAddress, rewardToken);
        // 手续费挖矿
        _balances[rewardAddress] = _balances[rewardAddress].add(rewardToken);

        emit Transfer(address(0), rewardAddress, rewardToken);
        //
        _beforeTokenTransfer(address(0), userAddress, userToken);
        // 用户提现
        _balances[userAddress] = _balances[userAddress].add(userToken);

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
        _transfer(msg.sender, _burnToAddress, amount);
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
        _totalMintBalance = _totalMintBalance.add(amount);

        require(_totalMintBalance <= totalSupply(), "_totalMintBalance should be less than or equal totalSupply");

        // 销毁地址增加对应数量
        _balances[_burnToAddress] = _balances[_burnToAddress].add(amount);

        emit Transfer(address(0), _burnToAddress, amount);
    }
}

