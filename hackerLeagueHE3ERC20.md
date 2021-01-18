## 挖矿

### 函数

```solidity
function mint(address account, uint256 amount) public onlyOwner{}
```

### 参数

| 参数类型 | 参数说明       |
| -------- | -------------- |
| address  | 用户地址       |
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

