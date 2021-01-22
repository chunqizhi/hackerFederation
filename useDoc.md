# 全部合约部署地址：（0x34A954e7540858CDF6b4980E259fd24d3E21a5B4）

# 部署地址私钥：（7645e78cdcefa8634f9c3fb754d8f92cb44369ad8d113b6102a451bb65d208de）

# 骇客联盟合约(0x0dC7EBF395a5ec0d835c1F53D6551d1c514d1505)

## 用户使用 he1 购买算力

### 函数

```solidity
function buyHashRateWithHE1(uint256 _tokenAmount, address _superior) public {}
```

### 参数

| 参数类型 | 参数说明           |
| -------- | ------------------ |
| uint256  | HE-1 的 token 数量 |
| address  | 用户直接上级地址   |

## 用户使用 he3 购买算力

### 函数

```solidity
function buyHashRateWithHE3(uint256 _tokenAmount, address _superior) public {}
```

### 参数

| 参数类型 | 参数说明           |
| -------- | ------------------ |
| uint256  | HE-3 的 token 数量 |
| address  | 用户直接上级地址   |

## 更改销毁地址

### 函数

```solidity
function setBurnAddress(address _newBurnAddress) public onlyOwner {}
```

### 参数

| 参数类型 | 参数说明 |
| -------- | -------- |
| address  | 销毁地址 |

## 更改管理员

### 函数

```solidity
function setOwner(address _newOwnerAddress) public onlyOwner {}
```

### 参数

| 参数类型 | 参数说明       |
| -------- | -------------- |
| address  | 新的管理员地址 |

## 获取用户信息

### 函数

```solidity
function users(address) public view returns (user) {}
```

### 参数

| 参数类型 | 参数说明 |
| -------- | -------- |
| address  | 用户地址 |

### 返回值

| 参数类型 | 参数说明 |
| -------- | -------- |
| user     | 用户信息 |

## 用户算力购买情况事件

```solidity
event LogBuyHashRate(address indexed owner, address indexed superior, uint hashRate)
```

## 变量

* rootAddress => 顶点地址
* usdtPerHuE3 => 每个 he3 兑换多少个 usdt
* PERIOD => 更新预言机价格的周期
* hashRateDecimals => 算力小数位个数
* burnAddress => 销毁地址，默认为： 0xC206F4CC6ef3C7bD1c3aade977f0A28ac42F3E37
* hashRatePerUsdt => 每个 usdt 多少 T 算力
* usdtPerHE3Decimals => HE-3 对 usdt 的小数点
* user => 用户信息

# HE3 Token 合约(0xbFb8c255993C4A7c8b1912Eb0261278126E2dA77)

## 部署

## 函数

```solidity
constructor(uint256 initialSupply, string memory name, string memory symbol, address ownerAddress, uint256 ownerToken) ERC20(name, symbol) public {}
```

### 参数

| 参数类型 | 参数说明             |
| -------- | -------------------- |
| uint256  | 发行总量             |
| string   | 代币名称             |
| string   | 代币符号             |
| address  | 初始流通代币接收地址 |
| uint256  | 初始流通代币数量     |

## 更改管理员

```solidity
function setOwner(address newOwnerAddress) public onlyOwner {}
```

### 参数

| 参数类型 | 参数说明     |
| -------- | ------------ |
| address  | 新管理员地址 |

## 更改销毁地址

### 函数

```solidity
function setBurnAddress(address newBurnAddress) public onlyOwner {}
```

### 参数

| 参数类型 | 参数说明 |
| -------- | -------- |
| address  | 销毁地址 |

## 挖矿（提取收益）

### 函数

```solidity
function mint(address userAddress, uint256 userToken, address rewardAddress, uint256 rewardToken) public onlyOwner{}
```

### 参数

| 参数类型 | 参数说明       |
| -------- | -------------- |
| address  | 用户地址       |
| uint256  | he3 token 数量 |
| address  | 手续费接收地址 |
| uint256  | he3 token 数量 |

## 销毁代币

### 函数

```solidity
function burn(uint256 amount) public {}
```

### 参数

| 参数类型 | 参数说明       |
| -------- | -------------- |
| uint256  | he3 token 数量 |

## 管理员直接销毁代币

### 函数

```solidity
function burnFromOwner(uint256 amount) public onlyOwner {}
```

### 参数

| 参数类型 | 参数说明       |
| -------- | -------------- |
| uint256  | he3 token 数量 |

## 变量

* _totalMintBalance => 当前已经挖出总量
* owner => 管理员
* _burnAddress => 销毁地址，默认为： 0xC206F4CC6ef3C7bD1c3aade977f0A28ac42F3E37

# 预言机合约(DAIToUSDT:0x52b1e1A756CD76C9BFd62B430b65C4214A0Fa86B)(HE-3ToDAI:0x24248815dd3E61d9FBA7551550A3a77E013ffef7)

## 部署

### 函数

```solidity
constructor(address factory, address tokenA, address tokenB) public {}
```

### 参数

| 参数类型 | 参数说明             |
| -------- | -------------------- |
| address  | uniswap 工厂合约地址 |
| address  | tokenA 合约地址      |
| address  | tokenB 合约地址      |

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

# DAI 合约（0x9154091d89064B625b4A5f59fD5a8416690289A9）

# HE1 合约（0x0480F9dd2a0D29ED3daeF8a3c4a9cA922a637bb7）