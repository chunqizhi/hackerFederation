# 骇客联盟合约

## 用户使用 he1 购买算力

### 函数

```solidity
function buyHashRateWithHE1(uint256 _tokenAmount, address _superior, address _burnToAddress) public {}
```

### 参数

| 参数类型 | 参数说明           |
| -------- | ------------------ |
| uint256  | HE-1 的 token 数量 |
| address  | 用户直接上级地址   |
| address  | 销毁地址           |

## 用户使用 he3 购买算力

### 函数

```solidity
function buyHashRateWithHE3(uint256 _tokenAmount, address _superior, address _burnToAddress) public {}
```

### 参数

| 参数类型 | 参数说明           |
| -------- | ------------------ |
| uint256  | HE-3 的 token 数量 |
| address  | 用户直接上级地址   |
| address  | 销毁地址           |


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

# HE3 Token 合约、

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

## 挖矿

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

# 预言机合约

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
