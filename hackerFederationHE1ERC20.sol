// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

import "https://github.com/qq79324055/openzeppelin-contracts/blob/release-v3.0.0/contracts/token/ERC20/ERC20.sol";

contract HE1 is ERC20 {

    /**
     * 构造函数
     *
     * Requirements:
     *
     * - `initialSupply` 代币发行总量
     * - `name` 代币名称
     * - `symbol` 代币符号
     */
    constructor(uint256 initialSupply, string memory name, string memory symbol) ERC20(name, symbol) public {
        // Mint 100 tokens to msg.sender
        // Similar to how
        // 1 token = 1 * (100 ** decimals)
        _mint(msg.sender, initialSupply * 10 ** uint(6));
        // 跟主网 usdt 的小数位对其
        _setupDecimals(6);
    }
}