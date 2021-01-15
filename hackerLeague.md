## 用户购买算力

### 函数

```solidity
function buyHashRate(ERC20 _tokenAddress, uint256 _tokenAmount, address _superior) public {}
```

### 参数

| _tokenAddress | HE-1 或者 HE-3 的合约地址    |
| ------------- | ---------------------------- |
| _tokenAmount  | HE-1 或者 HE-3 的 token 数量 |
| _superior     | 用户上级地址                 |

## 用户提取收益（管理者触发）

### 函数

```solidity
function withdraw(ERC20 _tokenAddress, address _userAddress, uint _amount) public onlyOwner {}
```

### 参数

| _tokenAddress | HE-3 的合约地址         |
| ------------- | ----------------------- |
| _userAddress  | 用户地址                |
| _amount       | 提取 HE-3 的 token 数量 |

## 获取用户信息

### 函数

```solidity
function userInfo(address _userAddress) public view returns (user memory) {}
```

### 参数

| _userAddress |
| ------------ |
| 用户地址     |

### 返回值

| user     |
| -------- |
| 用户信息 |

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

| _userAddress |
| ------------ |
| 用户地址     |

### 返回值

| address      |
| ------------ |
| 用户上级地址 |

## 获取用户算力

### 函数

```solidity
function userSuperior(address _userAddress) public view returns (uint) {}
```

### 参数

| _userAddress |
| ------------ |
| 用户地址     |

### 返回值

| uint     |
| -------- |
| 用户算力 |

## 判断是否为系统用户

### 函数

```solidity
function userSuperior(address _userAddress) public view returns (bool) {}
```

### 参数

| _userAddress |
| ------------ |
| 用户地址     |

### 返回值

| bool          |
| ------------- |
| true or false |