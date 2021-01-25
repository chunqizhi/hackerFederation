# 全部合约部署地址：（0x34A954e7540858CDF6b4980E259fd24d3E21a5B4）

# 部署地址私钥：（7645e78cdcefa8634f9c3fb754d8f92cb44369ad8d113b6102a451bb65d208de）

# 骇客联盟合约(0xB91202E67B133Dc525e6c130c8DD7F026C9c0559)

## 变量

```solidity
    // 获取 HE3/HE1 与 DAI 的交易对
    HackerFederationOracle public oracleHE3ToDai = HackerFederationOracle(0x036cc7Ea3a09296f3f7B0019c691decd40D689F4);
    // 获取 DAI 与 USDT 的交易对
    HackerFederationOracle public oracleDaiToUsdt = HackerFederationOracle(0xc51aA3f76B1Ab57c50ddBE358B0f7C10e3aDaeFD);
    // 更新预言机周期
    uint public constant PERIOD = 2 minutes;
    // 初始兑换值
    uint public usdtPerHE3 = 2000000;
    // 算力小数点位数
    uint public hashRateDecimals = 5;
    // 每 10 usdt = 1 T
    uint public hashRatePerUsdt = 10;
    // usdtPerHE3 的小数点位数
    uint public usdtPerHE3Decimals = 6;
    // 对应 oracleHE3ToDai 预言机的 blockTimestampLast
    uint  public OracleHE3ToDaiBlockTimestampLast = oracleHE3ToDai.blockTimestampLast();
    // 对应 oracleDaiToUsdt 预言机的 blockTimestampLast
    uint  public OracleDaiToUsdtBlockTimestampLast = oracleDaiToUsdt.blockTimestampLast();
    //
    address public owner;
    // 顶点地址
    address public rootAddress = 0x3585762FBFf4b2b7D92Af16b2BCfa90FE3562087;
    // 销毁地址
    address public burnAddress = 0xC206F4CC6ef3C7bD1c3aade977f0A28ac42F3E37;
    // DAI erc20 代币地址
    address public daiTokenAddress = 0x87ac13ca508e8Bb9D0DD0411A2289D8f2bFf1E65;
    // HE3 erc20 代币地址
    address public he3TokenAddress = 0xa1B33bE25f1A186C605a6297Be217c35bf41e8BB;
    // HE1 erc20 代币地址
    address public he1TokenAddress = 0x32356240342D0607937D8e3C82a73c4f5bEbfd41;
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

# HE3 Token 合约(0x33eCeB4eBdF23eB3331D676C52fCf014b4f35f29)

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
    address public _initialAddress = 0xe073864581f36e2e86D15987114e7B61c1124F36;
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


# HE1 合约（0x99FFb8fFe9a58aFD1f4D73f91b146a4B76753161）