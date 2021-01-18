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

## 用户提取收益（管理者触发）

### 函数

```solidity
function withdraw(address _userAddress, uint _amount) public onlyOwner {}
```

### 参数

| 参数类型 | 参数说明                                          |
| ------------- | ------------------------------------------------------------ |
| address  | 用户地址 |
| uint | 提取 HE-3 的 token 数量（手续费需用户支付，后端已经扣除等价的 HE-3） |

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

## 用户收益提取记录事件

```solidity
event LogWithdraw(address indexed owner, uint reward)
```

