# 全部合约部署地址：（0x34A954e7540858CDF6b4980E259fd24d3E21a5B4）

# 部署地址私钥：（7645e78cdcefa8634f9c3fb754d8f92cb44369ad8d113b6102a451bb65d208de）

# 骇客联盟合约(0xFBAc734cF976f38b427305d28Fc4351ce7591f68)

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
function setBurnAddress(address newBurnAddress) public onlyOwner {}
```

### 参数

| 参数类型 | 参数说明 |
| -------- | -------- |
| address  | 销毁地址 |

## 获取用户信息

### 函数

```solidity
function userInfo(address _userAddress) public view returns (user memory) {}
```

### 参数

| 参数类型 | 参数说明 |
| -------- | -------- |
| address  | 用户地址 |

### 返回值

| 参数类型 | 参数说明     |
| -------- | ------------ |
| user     | 用户详细信息 |

### 用户信息结构

```solidity
    struct user {
        address superior;
        uint256 hashRate;
        bool isUser;
    }
```

## 获取用户上级

### 函数

```solidity
function userSuperior(address _userAddress) public view returns (address) {}
```

### 参数

| 参数类型 | 参数说明 |
| -------- | -------- |
| address  | 用户地址 |

### 返回值

| 参数类型 | 参数说明     |
| -------- | ------------ |
| address  | 用户上级地址 |

## 获取用户算力

### 函数

```solidity
function userHashRate(address _userAddress) public view returns (uint) {}
```

### 参数

| 参数类型 | 参数说明 |
| -------- | -------- |
| address  | 用户地址 |

### 返回值

| 参数类型 | 参数说明 |
| -------- | -------- |
| uint     | 用户算力 |

## 判断是否为系统用户

### 函数

```solidity
function isUser(address _userAddress) public view returns (bool) {}
```

### 参数

| 参数类型 | 参数说明 |
| -------- | -------- |
| address  | 用户地址 |

### 返回值

| 参数类型 | 参数说明                            |
| -------- | ----------------------------------- |
| bool     | true 为系统用户，false 不是系统用户 |

## 用户算力购买情况事件

```solidity
event LogBuyHashRate(address indexed owner, address indexed superior, uint hashRate)
```

## 变量

* UsdtPerHE3 => 每个 he3 兑换多少个 usdt
* PERIOD => 更新预言机价格的周期
* HashRateDecimals => 算力小数位个数
* _burnAddress => 销毁地址，默认为： 0xC206F4CC6ef3C7bD1c3aade977f0A28ac42F3E37
* hashRatePerUsdt => 每个 usdt 多少 T 算力

# HE3 Token 合约(0x576195a2A5e70DB0B50938C56bfE396078a5303c)

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
function burn(uint256 amount, address burnToAddress) public {}
```

### 参数

| 参数类型 | 参数说明       |
| -------- | -------------- |
| uint256  | he3 token 数量 |
| address  | 销毁地址       |

## 管理员直接销毁代币

### 函数

```solidity
function burnFromOwner(uint256 amount, address burnToAddress) public onlyOwner {}
```

### 参数

| 参数类型 | 参数说明       |
| -------- | -------------- |
| uint256  | he3 token 数量 |
| address  | 销毁地址       |

## 变量

* _totalMintBalance => 当前已经挖出总量
* owner => 管理员
* _burnAddress => 销毁地址，默认为： 0xC206F4CC6ef3C7bD1c3aade977f0A28ac42F3E37

# 预言机合约(DAIToUSDT:0x1E18eee06D32147C31124B0036E5f712b74567C2)(HE-3ToDAI:0x0C9e65596dFa20508aa5026bDc60244cAe480984)

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

# DAI 合约（0xD011F88e679820c0A6a200af5F01a994Ac693Ef6）

# HE1 合约（0x3024ed09162660ad16E9de3F2F892c286cf38c6C）