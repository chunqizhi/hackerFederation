// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.0/contracts/token/ERC20/ERC20.sol";

contract HE3 is ERC20 {

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
        _mint(msg.sender, initialSupply * 10 ** uint(decimals()));
    }

    /**
     * 销毁代币
     * 该地址需要有超过 _amount 的数量
     *
     * Requirements:
     *
     * - `_amount` 销毁 HE-3 token 数量
     */
    function burnToken(uint256 _amount) public {
        _burn(msg.sender, _amount);
    }
}