// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface Balance {
    function balanceOf(address account) external view returns (uint256);
}

interface TransferFrom {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract HackerFederation {
    // 算力小数点位数
    uint public hashRateDecimals = 5;
    // 每 10 usdt = 1 T
    uint public hashRatePerUsdt = 10;
    // daiPerHe3 的小数点位数
    uint public daiPerHe3Decimals = 6;
    //
    address public owner;
    // 顶点地址
    address public rootAddress = 0x3585762FBFf4b2b7D92Af16b2BCfa90FE3562087;
    // 销毁地址
    address public burnAddress = 0xC206F4CC6ef3C7bD1c3aade977f0A28ac42F3E37;

    // dai 对 he3 币对 address
    address public daiToHe3Address = address(0x00a51d3b6b1a8e3941751b10ce310258651d9dd5e3);

    // Dai erc20 代币地址
    address public daiTokenAddress = 0xE00757a0251c2D9CD20314d8721AC0B2a32F1c9D;
    Balance balanceDai = Balance(daiTokenAddress);
    // HE3 erc20 代币地址
    address public he3TokenAddress = 0xd9d3A935090BF031977427954b15b818e058b1FC;
    Balance balanceHe3 = Balance(he3TokenAddress);

    // HE1 erc20 代币地址
    address public he1TokenAddress = 0xd9d3A935090BF031977427954b15b818e058b1FC;

    // 用户信息
    struct User {
        address superior;
        uint256 hashRate;
        bool isUser;
    }
    // 保存用户信息对应关系
    mapping(address => User) public users;

    // 用户算力购买情况事件
    event LogBuyHashRate(address indexed owner, address indexed superior, uint hashRate);

    constructor() public {
        //
        owner = msg.sender;
    }

    // 函数修改器，只有 owner 满足条件
    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }

    /**
     * 用户使用 he1 购买算力
     * 需要该用户拥有 HE-1 代币
     *
     * Requirements:
     *
     * - `_tokenAmount` 使用 token 数量购买算力
     * - `_superior` 直接上级
     */
    function buyHashRateWithHE1(uint256 _tokenAmount, address _superior) public {
        _buyHashRate(he1TokenAddress, _tokenAmount, _tokenAmount, _superior);
    }

    /**
     * 用户使用 he3 购买算力
     * 需要该用户拥有 HE-3 代币
     *
     * Requirements:
     *
     * - `_tokenAmount` 使用 token 数量购买算力
     * - `_superior` 直接上级
     */
    function buyHashRateWithHE3(uint256 _tokenAmount, address _superior) public {
        // 1 个 he3 = 多少个 dai，含 6 位小数
        uint price = getDaiPerHe3();
        // 当前共多少 dai，除去 6 位小数，再除去 12 位以保持与 usdt 位数对齐
        uint total = _tokenAmount * price / 10 ** daiPerHe3Decimals / 10 ** 12;
        //
        _buyHashRate(he3TokenAddress, _tokenAmount, total, _superior);
    }

    /**
     * 用户购买算力
     * 需要该用户拥有 HE-1 或者 HE-3 代币
     *
     * Requirements:
     *
     * - `_token` HE-1 或者 HE-3 的合约地址
     * - `_tokenAmount` 使用 token 数量购买算力
     * - `_usdtAmount` _tokenAmount 与 usdt 的价格
     * - `_superior` 直接上级
     */
    function _buyHashRate(address _tokenAddress,uint _tokenAmount, uint256 _usdtAmount, address _superior) internal {
        // 判断上级是否是 user 或 rootAddress，如果都不是，抛出错误
        if (!(users[_superior].isUser || _superior == rootAddress)) {
            require(users[_superior].isUser, "Superior should be a user or rootAddress");
        }
        // 是否拥有 _amount 数量的 _token 代币
        //        require(
        //            _tokenAddress.allowance(msg.sender, address(this)) >= _tokenAmount,
        //            "Token allowance too low"
        //        );
        // 销毁对应的代币
        bool sent = TransferFrom(_tokenAddress).transferFrom(msg.sender, burnAddress, _tokenAmount);
        require(sent, "Token transfer failed");
        // 10 000000 USDT = 1 00000T, 10 为小数点
        // 计算当前能买多少算力
        uint hashRate = _usdtAmount / hashRatePerUsdt / 10;
        // 单次购买不的少于 1T 算力
        require(hashRate >= 1 * 10 ** hashRateDecimals, "Need buy 1T at least");
        //
        if (users[msg.sender].isUser) {
            // 再次购买，不改变直接上级，直接更新算力
            users[msg.sender].hashRate += hashRate;
        } else {
            // 第一次购买算力，更新用户信息
            users[msg.sender].superior = _superior;
            users[msg.sender].hashRate = hashRate;
            users[msg.sender].isUser = true;
        }
        // 触发购买算力事件
        emit LogBuyHashRate(msg.sender, _superior, hashRate);
    }

    // 更新管理员地址
    function updateOwnerAddress(address _newOwnerAddress) public onlyOwner {
        owner = _newOwnerAddress;
    }

    // 更新销毁地址
    function updateBurnAddress(address _newBurnAddress) public onlyOwner {
        burnAddress = _newBurnAddress;
    }

    // 更新 he3 合约地址
    function updateHe3TokenAddress(address _he3TokenAddress) public onlyOwner {
        he3TokenAddress = _he3TokenAddress;
        balanceHe3 = Balance(he3TokenAddress);
    }

    // 更新 he1 合约地址
    function updateHe1TokenAddress(address _he1TokenAddress) public onlyOwner {
        he1TokenAddress = _he1TokenAddress;
    }

    // 更新 dai 合约地址
    function updateDaiToHe3AddressAddress(address _daiToHe3Address) public onlyOwner {
        daiToHe3Address = _daiToHe3Address;
    }

    // 更新 he3 对 dai 币对合约地址
    function updateDaiTokenAddress(address _daiTokenAddress) public onlyOwner {
        daiTokenAddress = _daiTokenAddress;
        balanceDai = Balance(daiTokenAddress);
    }

    /**
     * 判断该地址是否为用户
     *
     * Requirements:
     *
     * - `_userAddress` 用户地址
     */
    function isUser(address _userAddress) public view returns (bool) {
        return users[_userAddress].isUser;
    }

    // 1 : 2 = he3 : dai
    // 1 he3 = 2 dai
    // 获取 1 个 he3 兑换多少个 dai
    function getDaiPerHe3() public view returns (uint) {
        return balanceDai.balanceOf(daiToHe3Address) * 10 ** daiPerHe3Decimals / balanceHe3.balanceOf(daiToHe3Address);
    }
}