# 全部合约部署地址：（0x34A954e7540858CDF6b4980E259fd24d3E21a5B4）

# 部署地址私钥：（7645e78cdcefa8634f9c3fb754d8f92cb44369ad8d113b6102a451bb65d208de）

# 骇客联盟合约(0x629a33cE67ac63b7d2f668a99fAfd26e5DB8B622)

## 变量

```solidity
    using SafeMath for uint256;

    // 控制 he1 与 usdt 的比值
    uint256 public usdtDecimals = 0;
    // 算力小数点位数
    uint256 public hashRateDecimals = 5;
    // 每 10 usdt = 1 T
    uint256 public hashRatePerUsdt = 10;
    // daiPerHe3 的小数点位数
    uint256 public daiPerHe3Decimals = 6;
    //
    address public owner;
    // 顶点地址
    address public rootAddress = 0x3585762FBFf4b2b7D92Af16b2BCfa90FE3562087;
    // 销毁地址
    address public burnAddress = 0xC206F4CC6ef3C7bD1c3aade977f0A28ac42F3E37;

    // dai 对 he3 币对 address
    address public daiToHe3Address = address(0x00089b20bbded1cb479459969e3863cb6bf64edc9f);

    // Dai erc20 代币地址
    address public daiTokenAddress = 0x22d5C3DeD529F9BE1083E5b44f8De7975B721348;
    Token tokenDai = Token(daiTokenAddress);
    // HE3 erc20 代币地址
    address public he3TokenAddress = 0x7a9064552D247a8c3a43d3d5aA60C73F766da8b5;
    Token tokenHe3 = Token(he3TokenAddress);

    // HE1 erc20 代币地址
    address public he1TokenAddress = 0xF72e4d8B029c4fC6a97c59EC3AF33b2cCcC52715;

    // 用户信息
    struct User {
        address superior;
        uint256 hashRate;
        bool isUser;
    }
    // 保存用户信息对应关系
    mapping(address => User) public users;
```

## 用户算力购买情况事件

```solidity
event LogBuyHashRate(address indexed owner, address indexed superior, uint hashRate)
```

## 构造函数

```solidity
constructor() public {}
```

## 函数修改器

```solidity
modifier onlyOwner() {}
```

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

## 更改管理员

### 函数

```solidity
function updateOwnerAddress(address _newOwnerAddress) public onlyOwner {}
```

### 参数

| 参数类型 | 参数说明       |
| -------- | -------------- |
| address  | 新的管理员地址 |

## 更改销毁地址

### 函数

```solidity
function updateBurnAddress(address _newBurnAddress) public onlyOwner {}
```

### 参数

| 参数类型 | 参数说明 |
| -------- | -------- |
| address  | 销毁地址 |

## 更改 he3 合约地址

### 函数

```solidity
function updateHe3TokenAddress(address _he3TokenAddress) public onlyOwner {}
```

### 参数

| 参数类型 | 参数说明      |
| -------- | ------------- |
| address  | 新的 HE3 地址 |

## 更改 he1 合约地址

### 函数

```solidity
function updateDaiToHe3AddressAddress(address _daiToHe3Address) public onlyOwner {}
```

### 参数

| 参数类型 | 参数说明      |
| -------- | ------------- |
| address  | 新的 HE1 地址 |

## 更改 dai 合约地址

### 函数

```solidity
function updateDaiTokenAddress(address _daiTokenAddress) public onlyOwner {}
```

### 参数

| 参数类型 | 参数说明      |
| -------- | ------------- |
| address  | 新的 DAI 地址 |

## 更改 he3 对 dai 币对合约地址

### 函数

```solidity
function updateDaiTokenAddress(address _daiTokenAddress) public onlyOwner {}
```

### 参数

| 参数类型 | 参数说明                     |
| -------- | ---------------------------- |
| address  | 新的 he3 对 dai 币对合约地址 |

## 更改 usdtDecimals 变量的值

### 函数

```solidity
function updateUsdtDecimals(uint256 _newUsdtDecimals) public onlyOwner {}
```

### 参数

| 参数类型 | 参数说明               |
| -------- | ---------------------- |
| uint256  | 新的 usdtDecimals 的值 |

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

## 判断地址是否为用户

### 函数

```solidity
function isUser(address _userAddress) public view returns (bool) {}
```

### 参数

| 参数类型 | 参数说明 |
| -------- | -------- |
| address  | 用户地址 |

### 返回值

| 参数类型 | 参数说明      |
| -------- | ------------- |
| bool     | true or false |

## 获取 1 个 he3 兑换多少个 dai（含 6 位小数）

### 函数

```solidity
function getDaiPerHe3() public view returns (uint) {}
```

### 返回值

| 参数类型 | 参数说明                     |
| -------- | ---------------------------- |
| uint     | 获取 1 个 he3 兑换多少个 dai |

# HE3 Token 合约(0x3343798856cF418f568C8F9AC5171399147C1c38)

## 变量

```solidity
    // 当前已经挖出总量
    uint256 public _totalMintBalance;
    // 管理员
    address public _owner;
    // 销毁地址
    address public _burnAddress = 0xC206F4CC6ef3C7bD1c3aade977f0A28ac42F3E37;
    // 手续费接收地址
    address public _feeAddress = 0xC5EA2EA8F6428Dc2dBf967E5d30F34E25D7ef5B8;
    // 初始流通代币接收地址
    address public _initialAddress = 0x34A954e7540858CDF6b4980E259fd24d3E21a5B4;
    // 初始流通代币数量
    uint256 public _initialToken = 1000;
```

## 构造函数

```solidity
constructor(uint256 initialSupply, string memory name, string memory symbol) ERC20(name, symbol) public {}
```

### 参数

| 参数类型 | 参数说明 |
| -------- | -------- |
| uint256  | 发行总量 |
| string   | 代币名称 |
| string   | 代币符号 |

## 函数修改器

```solidity
modifier onlyOwner() {}
```

## 更改管理员地址

```solidity
function updateOwnerAddress(address newOwnerAddress) public onlyOwner {}
```

### 参数

| 参数类型 | 参数说明     |
| -------- | ------------ |
| address  | 新管理员地址 |

## 更改销毁地址

### 函数

```solidity
function updateBurnAddress(address newBurnAddress) public onlyOwner {}
```

### 参数

| 参数类型 | 参数说明 |
| -------- | -------- |
| address  | 销毁地址 |

## 更改接收手续费地址

### 函数

```solidity
function updateFeeAddress(address newFeeAddress) public onlyOwner {}
```

### 参数

| 参数类型 | 参数说明           |
| -------- | ------------------ |
| address  | 新的接收手续费地址 |

## 挖矿（提取收益）

### 函数

```solidity
function mint(address userAddress, uint256 userToken, uint256 feeToken) public onlyOwner{}
```

### 参数

| 参数类型 | 参数说明              |
| -------- | --------------------- |
| address  | 用户地址              |
| uint256  | he3 token 数量        |
| uint256  | 手续费 he3 token 数量 |

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


# HE1 合约（0xbd7805F93a41191548bd89F1eF5602bb8620449c）