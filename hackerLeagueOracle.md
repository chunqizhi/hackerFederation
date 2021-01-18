## 更新合约状态变量

### 函数

```solidity
function update() external {}
```

### 从价格交易对获取对应的币对价格

```solidity
function consult(address token, uint amountIn) external view returns (uint amountOut) {}
```

### 参数

| 参数类型 | 参数说明         |
| -------- | ---------------- |
| address  | ERC20 token 地址 |
| uint     | ERC20 token 数量 |

### 返回值

| 参数类型 | 参数说明     |
| -------- | ------------ |
| uint     | 币对兑换价格 |

