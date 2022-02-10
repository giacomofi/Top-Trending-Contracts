['// SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity 0.6.8;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'interface iERC20 {\n', '    function name() external view returns (string memory);\n', '    function symbol() external view returns (string memory);\n', '    function decimals() external view returns (uint);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address account) external view returns (uint);\n', '    function transfer(address, uint) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '    function approve(address, uint) external returns (bool);\n', '    function transferFrom(address, address, uint) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', 'interface iBASE {\n', '    function secondsPerEra() external view returns (uint);\n', '    // function DAO() external view returns (iDAO);\n', '}\n', 'interface iUTILS {\n', '    function calcPart(uint bp, uint total) external pure returns (uint part);\n', '    function calcShare(uint part, uint total, uint amount) external pure returns (uint share);\n', '    function calcSwapOutput(uint x, uint X, uint Y) external pure returns (uint output);\n', '    function calcSwapFee(uint x, uint X, uint Y) external pure returns (uint output);\n', '    function calcStakeUnits(uint a, uint A, uint v, uint S) external pure returns (uint units);\n', '    // function calcAsymmetricShare(uint s, uint T, uint A) external pure returns (uint share);\n', '    // function getPoolAge(address token) external view returns(uint age);\n', '    function getPoolShare(address token, uint units) external view returns(uint baseAmt, uint tokenAmt);\n', '    function getPoolShareAssym(address token, uint units, bool toBase) external view returns(uint baseAmt, uint tokenAmt, uint outputAmt);\n', '    function calcValueInBase(address token, uint amount) external view returns (uint value);\n', '    function calcValueInToken(address token, uint amount) external view returns (uint value);\n', '    function calcValueInBaseWithPool(address payable pool, uint amount) external view returns (uint value);\n', '}\n', 'interface iDAO {\n', '    function ROUTER() external view returns(address);\n', '    function UTILS() external view returns(iUTILS);\n', '    function FUNDS_CAP() external view returns(uint);\n', '}\n', '\n', '// SafeMath\n', 'library SafeMath {\n', '\n', '    function add(uint a, uint b) internal pure returns (uint)   {\n', '        uint c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function mul(uint a, uint b) internal pure returns (uint) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint c = a * b;\n', '        require(c / a == b, "SafeMath");\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath");\n', '    }\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath");\n', '    }\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Pool_Vether is iERC20 {\n', '    using SafeMath for uint;\n', '\n', '    address public BASE;\n', '    address public TOKEN;\n', '    iDAO public DAO;\n', '\n', '    uint public one = 10**18;\n', '\n', '    // ERC-20 Parameters\n', '    string _name; string _symbol;\n', '    uint public override decimals; uint public override totalSupply;\n', '    // ERC-20 Mappings\n', '    mapping(address => uint) private _balances;\n', '    mapping(address => mapping(address => uint)) private _allowances;\n', '\n', '    uint public genesis;\n', '    uint public baseAmt;\n', '    uint public tokenAmt;\n', '    uint public baseAmtStaked;\n', '    uint public tokenAmtStaked;\n', '    uint public fees;\n', '    uint public volume;\n', '    uint public txCount;\n', '    \n', '    // Only Router can execute\n', '    modifier onlyRouter() {\n', '        _isRouter();\n', '        _;\n', '    }\n', '\n', '    function _isRouter() internal view {\n', '        require(msg.sender == _DAO().ROUTER(), "RouterErr");\n', '    }\n', '\n', '    function _DAO() internal view returns(iDAO) {\n', '        return DAO;\n', '    }\n', '\n', '    constructor (address _base, address _token, iDAO _dao) public payable {\n', '\n', '        BASE = _base;\n', '        TOKEN = _token;\n', '        DAO = _dao;\n', '\n', '        string memory poolName = "VetherPoolV1-";\n', '        string memory poolSymbol = "VPT1-";\n', '\n', '        if(_token == address(0)){\n', '            _name = string(abi.encodePacked(poolName, "Ethereum"));\n', '            _symbol = string(abi.encodePacked(poolSymbol, "ETH"));\n', '        } else {\n', '            _name = string(abi.encodePacked(poolName, iERC20(_token).name()));\n', '            _symbol = string(abi.encodePacked(poolSymbol, iERC20(_token).symbol()));\n', '        }\n', '        \n', '        decimals = 18;\n', '        genesis = now;\n', '    }\n', '\n', '    function _checkApprovals() external onlyRouter{\n', '        if(iERC20(BASE).allowance(address(this), _DAO().ROUTER()) == 0){\n', '            if(TOKEN != address(0)){\n', '                iERC20(TOKEN).approve(_DAO().ROUTER(), (2**256)-1);\n', '            }\n', '        iERC20(BASE).approve(_DAO().ROUTER(), (2**256)-1);\n', '        }\n', '    }\n', '\n', '    receive() external payable {}\n', '\n', '    //========================================iERC20=========================================//\n', '    function name() public view override returns (string memory) {\n', '        return _name;\n', '    }\n', '    function symbol() public view override returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function balanceOf(address account) public view override returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '    // iERC20 Transfer function\n', '    function transfer(address to, uint value) public override returns (bool success) {\n', '        __transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '    // iERC20 Approve function\n', '    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n', '        __approve(msg.sender, spender, amount);\n', '        return true;\n', '    }\n', '    function __approve(address owner, address spender, uint256 amount) internal virtual {\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '    // iERC20 TransferFrom function\n', '    function transferFrom(address from, address to, uint value) public override returns (bool success) {\n', "        require(value <= _allowances[from][msg.sender], 'AllowanceErr');\n", '        _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(value);\n', '        __transfer(from, to, value);\n', '        return true;\n', '    }\n', '\n', '    // Internal transfer function\n', '    function __transfer(address _from, address _to, uint _value) private {\n', "        require(_balances[_from] >= _value, 'BalanceErr');\n", "        require(_balances[_to] + _value >= _balances[_to], 'BalanceErr');\n", '        _balances[_from] =_balances[_from].sub(_value);\n', '        _balances[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    // Router can mint\n', '    function _mint(address account, uint256 amount) external onlyRouter {\n', '        totalSupply = totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        _allowances[account][DAO.ROUTER()] += amount;\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '    // Burn supply\n', '    function burn(uint256 amount) public virtual {\n', '        __burn(msg.sender, amount);\n', '    }\n', '    function burnFrom(address from, uint256 value) public virtual {\n', "        require(value <= _allowances[from][msg.sender], 'AllowanceErr');\n", '        _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(value);\n', '        __burn(from, value);\n', '    }\n', '    function __burn(address account, uint256 amount) internal virtual {\n', '        _balances[account] = _balances[account].sub(amount, "BalanceErr");\n', '        totalSupply = totalSupply.sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '\n', '\n', '    //==================================================================================//\n', '    // Extended Asset Functions\n', '\n', '    // TransferTo function\n', '    function transferTo(address recipient, uint256 amount) public returns (bool) {\n', '        __transfer(tx.origin, recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    // ETH Transfer function\n', '    function transferETH(address payable to, uint value) public payable onlyRouter returns (bool success) {\n', '        to.call{value:value}(""); \n', '        return true;\n', '    }\n', '\n', '    function sync() public {\n', '        if (TOKEN == address(0)) {\n', '            tokenAmt = address(this).balance;\n', '        } else {\n', '            tokenAmt = iERC20(TOKEN).balanceOf(address(this));\n', '        }\n', '    }\n', '\n', '    function add(address token, uint amount) public payable returns (bool success) {\n', '        if(token == BASE){\n', '            iERC20(BASE).transferFrom(msg.sender, address(this), amount);\n', '            baseAmt = baseAmt.add(amount);\n', '            return true;\n', '        } else if (token == TOKEN){\n', '            iERC20(TOKEN).transferFrom(msg.sender, address(this), amount);\n', '            tokenAmt = tokenAmt.add(amount); \n', '            return true;\n', '        } else if (token == address(0)){\n', '            require((amount == msg.value), "InputErr");\n', '            tokenAmt = tokenAmt.add(amount); \n', '        } else {\n', '            return false;\n', '        }\n', '    } \n', '\n', '    //==================================================================================//\n', '    // Data Model\n', '    function _incrementPoolBalances(uint _baseAmt, uint _tokenAmt)  external onlyRouter  {\n', '        baseAmt += _baseAmt;\n', '        tokenAmt += _tokenAmt;\n', '        baseAmtStaked += _baseAmt;\n', '        tokenAmtStaked += _tokenAmt; \n', '    }\n', '    function _setPoolBalances(uint _baseAmt, uint _tokenAmt, uint _baseAmtStaked, uint _tokenAmtStaked)  external onlyRouter  {\n', '        baseAmtStaked = _baseAmtStaked;\n', '        tokenAmtStaked = _tokenAmtStaked; \n', '        __setPool(_baseAmt, _tokenAmt);\n', '    }\n', '    function _setPoolAmounts(uint _baseAmt, uint _tokenAmt)  external onlyRouter  {\n', '        __setPool(_baseAmt, _tokenAmt); \n', '    }\n', '    function __setPool(uint _baseAmt, uint _tokenAmt) internal  {\n', '        baseAmt = _baseAmt;\n', '        tokenAmt = _tokenAmt; \n', '    }\n', '\n', '    function _decrementPoolBalances(uint _baseAmt, uint _tokenAmt)  external onlyRouter  {\n', '        uint _unstakedBase = _DAO().UTILS().calcShare(_baseAmt, baseAmt, baseAmtStaked);\n', '        uint _unstakedToken = _DAO().UTILS().calcShare(_tokenAmt, tokenAmt, tokenAmtStaked);\n', '        baseAmtStaked = baseAmtStaked.sub(_unstakedBase);\n', '        tokenAmtStaked = tokenAmtStaked.sub(_unstakedToken); \n', '        __decrementPool(_baseAmt, _tokenAmt); \n', '    }\n', ' \n', '    function __decrementPool(uint _baseAmt, uint _tokenAmt) internal  {\n', '        baseAmt = baseAmt.sub(_baseAmt);\n', '        tokenAmt = tokenAmt.sub(_tokenAmt); \n', '    }\n', '\n', '    function _addPoolMetrics(uint _volume, uint _fee) external onlyRouter  {\n', '        txCount += 1;\n', '        volume += _volume;\n', '        fees += _fee;\n', '    }\n', '\n', '}\n', '\n', 'contract Router_Vether {\n', '\n', '    using SafeMath for uint;\n', '\n', '    address public BASE;\n', '    address public DEPLOYER;\n', '    iDAO public DAO;\n', '\n', '    // uint256 public currentEra;\n', '    // uint256 public nextEraTime;\n', '    // uint256 public reserve;\n', '\n', '    uint public totalStaked; \n', '    uint public totalVolume;\n', '    uint public totalFees;\n', '    uint public unstakeTx;\n', '    uint public stakeTx;\n', '    uint public swapTx;\n', '\n', '    address[] public arrayTokens;\n', '    mapping(address=>address payable) private mapToken_Pool;\n', '    mapping(address=>bool) public isPool;\n', '\n', '    event NewPool(address token, address pool, uint genesis);\n', '    event Staked(address member, uint inputBase, uint inputToken, uint unitsIssued);\n', '    event Unstaked(address member, uint outputBase, uint outputToken, uint unitsClaimed);\n', '    event Swapped(address tokenFrom, address tokenTo, uint inputAmount, uint transferAmount, uint outputAmount, uint fee, address recipient);\n', '    // event NewEra(uint256 currentEra, uint256 nextEraTime, uint256 reserve);\n', '\n', '// Only Deployer can execute\n', '    modifier onlyDeployer() {\n', '        require(msg.sender == DEPLOYER, "DeployerErr");\n', '        _;\n', '    }\n', '\n', '    constructor () public payable {\n', '        BASE = 0x4Ba6dDd7b89ed838FEd25d208D4f644106E34279;\n', '        DEPLOYER = msg.sender;\n', '    }\n', '\n', '    receive() external payable {\n', '        buyTo(msg.value, address(0), msg.sender);\n', '    }\n', '\n', '    function setGenesisDao(address dao) public onlyDeployer {\n', '        DAO = iDAO(dao);\n', '    }\n', '\n', '    function _DAO() internal view returns(iDAO) {\n', '        return DAO;\n', '    }\n', '\n', '    function migrateRouterData(address payable oldRouter) public onlyDeployer {\n', '        totalStaked = Router_Vether(oldRouter).totalStaked();\n', '        totalVolume = Router_Vether(oldRouter).totalVolume();\n', '        totalFees = Router_Vether(oldRouter).totalFees();\n', '        unstakeTx = Router_Vether(oldRouter).unstakeTx();\n', '        stakeTx = Router_Vether(oldRouter).stakeTx();\n', '        swapTx = Router_Vether(oldRouter).swapTx();\n', '    }\n', '\n', '    function migrateTokenData(address payable oldRouter) public onlyDeployer {\n', '        uint tokenCount = Router_Vether(oldRouter).tokenCount();\n', '        for(uint i = 0; i<tokenCount; i++){\n', '            address token = Router_Vether(oldRouter).getToken(i);\n', '            address payable pool = Router_Vether(oldRouter).getPool(token);\n', '            isPool[pool] = true;\n', '            arrayTokens.push(token);\n', '            mapToken_Pool[token] = pool;\n', '        }\n', '    }\n', '\n', '    function purgeDeployer() public onlyDeployer {\n', '        DEPLOYER = address(0);\n', '    }\n', '\n', '    function createPool(uint inputBase, uint inputToken, address token) public payable returns(address payable pool){\n', '        require(getPool(token) == address(0), "CreateErr");\n', '        require(token != BASE, "Must not be Base");\n', '        require((inputToken > 0 && inputBase > 0), "Must get tokens for both");\n', '        Pool_Vether newPool = new Pool_Vether(BASE, token, DAO);\n', '        pool = payable(address(newPool));\n', '        uint _actualInputToken = _handleTransferIn(token, inputToken, pool);\n', '        uint _actualInputBase = _handleTransferIn(BASE, inputBase, pool);\n', '        mapToken_Pool[token] = pool;\n', '        arrayTokens.push(token);\n', '        isPool[pool] = true;\n', '        totalStaked += _actualInputBase;\n', '        stakeTx += 1;\n', '        uint units = _handleStake(pool, _actualInputBase, _actualInputToken, msg.sender);\n', '        emit NewPool(token, pool, now);\n', '        emit Staked(msg.sender, _actualInputBase, _actualInputToken, units);\n', '        return pool;\n', '    }\n', '\n', '    //==================================================================================//\n', '    // Staking functions\n', '\n', '    function stake(uint inputBase, uint inputToken, address token) public payable returns (uint units) {\n', '        units = stakeForMember(inputBase, inputToken, token, msg.sender);\n', '        return units;\n', '    }\n', '\n', '    function stakeForMember(uint inputBase, uint inputToken, address token, address member) public payable returns (uint units) {\n', '        address payable pool = getPool(token);\n', '        uint _actualInputToken = _handleTransferIn(token, inputToken, pool);\n', '        uint _actualInputBase = _handleTransferIn(BASE, inputBase, pool);\n', '        totalStaked += _actualInputBase;\n', '        stakeTx += 1;\n', '        require(totalStaked <= DAO.FUNDS_CAP(), "Must be less than Funds Cap");\n', '        units = _handleStake(pool, _actualInputBase, _actualInputToken, member);\n', '        emit Staked(member, _actualInputBase, _actualInputToken, units);\n', '        return units;\n', '    }\n', '\n', '\n', '    function _handleStake(address payable pool, uint _baseAmt, uint _tokenAmt, address _member) internal returns (uint _units) {\n', '        Pool_Vether(pool)._checkApprovals();\n', '        uint _S = Pool_Vether(pool).baseAmt().add(_baseAmt);\n', '        uint _A = Pool_Vether(pool).tokenAmt().add(_tokenAmt);\n', '        Pool_Vether(pool)._incrementPoolBalances(_baseAmt, _tokenAmt);                                                  \n', '        _units = _DAO().UTILS().calcStakeUnits(_tokenAmt, _A, _baseAmt, _S);  \n', '        Pool_Vether(pool)._mint(_member, _units);\n', '        return _units;\n', '    }\n', '\n', '    //==================================================================================//\n', '    // Unstaking functions\n', '\n', '    // Unstake % for self\n', '    function unstake(uint basisPoints, address token) public returns (bool success) {\n', '        require((basisPoints > 0 && basisPoints <= 10000), "InputErr");\n', '        uint _units = _DAO().UTILS().calcPart(basisPoints, iERC20(getPool(token)).balanceOf(msg.sender));\n', '        unstakeExact(_units, token);\n', '        return true;\n', '    }\n', '\n', '    // Unstake an exact qty of units\n', '    function unstakeExact(uint units, address token) public returns (bool success) {\n', '        address payable pool = getPool(token);\n', '        address payable member = msg.sender;\n', '        (uint _outputBase, uint _outputToken) = _DAO().UTILS().getPoolShare(token, units);\n', '        totalStaked = totalStaked.sub(_outputBase);\n', '        unstakeTx += 1;\n', '        _handleUnstake(pool, units, _outputBase, _outputToken, member);\n', '        emit Unstaked(member, _outputBase, _outputToken, units);\n', '        _handleTransferOut(token, _outputToken, pool, member);\n', '        _handleTransferOut(BASE, _outputBase, pool, member);\n', '        return true;\n', '    }\n', '\n', '    // // Unstake % Asymmetrically\n', '    function unstakeAsymmetric(uint basisPoints, bool toBase, address token) public returns (uint outputAmount){\n', '        uint _units = _DAO().UTILS().calcPart(basisPoints, iERC20(getPool(token)).balanceOf(msg.sender));\n', '        outputAmount = unstakeExactAsymmetric(_units, toBase, token);\n', '        return outputAmount;\n', '    }\n', '    // Unstake Exact Asymmetrically\n', '    function unstakeExactAsymmetric(uint units, bool toBase, address token) public returns (uint outputAmount){\n', '        address payable pool = getPool(token);\n', '        require(units < iERC20(pool).totalSupply(), "InputErr");\n', '        (uint _outputBase, uint _outputToken, uint _outputAmount) = _DAO().UTILS().getPoolShareAssym(token, units, toBase);\n', '        totalStaked = totalStaked.sub(_outputBase);\n', '        unstakeTx += 1;\n', '        _handleUnstake(pool, units, _outputBase, _outputToken, msg.sender);\n', '        emit Unstaked(msg.sender, _outputBase, _outputToken, units);\n', '        _handleTransferOut(token, _outputToken, pool, msg.sender);\n', '        _handleTransferOut(BASE, _outputBase, pool, msg.sender);\n', '        return _outputAmount;\n', '    }\n', '\n', '    function _handleUnstake(address payable pool, uint _units, uint _outputBase, uint _outputToken, address _member) internal returns (bool success) {\n', '        Pool_Vether(pool)._checkApprovals();\n', '        Pool_Vether(pool)._decrementPoolBalances(_outputBase, _outputToken);\n', '        Pool_Vether(pool).burnFrom(_member, _units);\n', '        return true;\n', '    } \n', '\n', '    //==================================================================================//\n', '    // Universal Swapping Functions\n', '\n', '    function buy(uint amount, address token) public payable returns (uint outputAmount, uint fee){\n', '        (outputAmount, fee) = buyTo(amount, token, msg.sender);\n', '        return (outputAmount, fee);\n', '    }\n', '    function buyTo(uint amount, address token, address payable member) public payable returns (uint outputAmount, uint fee) {\n', '        address payable pool = getPool(token);\n', '        Pool_Vether(pool)._checkApprovals();\n', '        uint _actualAmount = _handleTransferIn(BASE, amount, pool);\n', '        // uint _minusFee = _getFee(_actualAmount);\n', '        (outputAmount, fee) = _swapBaseToToken(pool, _actualAmount);\n', '        // addDividend(pool, outputAmount, fee);\n', '        totalStaked += _actualAmount;\n', '        totalVolume += _actualAmount;\n', '        totalFees += _DAO().UTILS().calcValueInBase(token, fee);\n', '        swapTx += 1;\n', '        _handleTransferOut(token, outputAmount, pool, member);\n', '        emit Swapped(BASE, token, _actualAmount, 0, outputAmount, fee, member);\n', '        return (outputAmount, fee);\n', '    }\n', '\n', '    // function _getFee(uint amount) private view returns(uint){\n', '    //     return amount\n', '    // }\n', '\n', '    function sell(uint amount, address token) public payable returns (uint outputAmount, uint fee){\n', '        (outputAmount, fee) = sellTo(amount, token, msg.sender);\n', '        return (outputAmount, fee);\n', '    }\n', '    function sellTo(uint amount, address token, address payable member) public payable returns (uint outputAmount, uint fee) {\n', '        address payable pool = getPool(token);\n', '        Pool_Vether(pool)._checkApprovals();\n', '        uint _actualAmount = _handleTransferIn(token, amount, pool);\n', '        (outputAmount, fee) = _swapTokenToBase(pool, _actualAmount);\n', '        // addDividend(pool, outputAmount, fee);\n', '        totalStaked = totalStaked.sub(outputAmount);\n', '        totalVolume += outputAmount;\n', '        totalFees += fee;\n', '        swapTx += 1;\n', '        _handleTransferOut(BASE, outputAmount, pool, member);\n', '        emit Swapped(token, BASE, _actualAmount, 0, outputAmount, fee, member);\n', '        return (outputAmount, fee);\n', '    }\n', '\n', '    function swap(uint inputAmount, address fromToken, address toToken) public payable returns (uint outputAmount, uint fee) {\n', '        require(fromToken != toToken, "InputErr");\n', '        address payable poolFrom = getPool(fromToken); address payable poolTo = getPool(toToken);\n', '        Pool_Vether(poolFrom)._checkApprovals();\n', '        Pool_Vether(poolTo)._checkApprovals();\n', '        uint _actualAmount = _handleTransferIn(fromToken, inputAmount, poolFrom);\n', '        uint _transferAmount = 0;\n', '        if(fromToken == BASE){\n', '            (outputAmount, fee) = _swapBaseToToken(poolFrom, _actualAmount);      // Buy to token\n', '            totalStaked += _actualAmount;\n', '            totalVolume += _actualAmount;\n', '            // addDividend(poolFrom, outputAmount, fee);\n', '        } else if(toToken == BASE) {\n', '            (outputAmount, fee) = _swapTokenToBase(poolFrom,_actualAmount);   // Sell to token\n', '            totalStaked = totalStaked.sub(outputAmount);\n', '            totalVolume += outputAmount;\n', '            // addDividend(poolFrom, outputAmount, fee);\n', '        } else {\n', '            (uint _yy, uint _feey) = _swapTokenToBase(poolFrom, _actualAmount);             // Sell to BASE\n', '            uint _actualYY = _handleTransferOver(BASE, poolFrom, poolTo, _yy);\n', '            totalStaked = totalStaked.add(_actualYY).sub(_actualAmount);\n', '            totalVolume += _yy; totalFees += _feey;\n', '            // addDividend(poolFrom, _yy, _feey);\n', '            (uint _zz, uint _feez) = _swapBaseToToken(poolTo, _actualYY);              // Buy to token\n', '            totalFees += _DAO().UTILS().calcValueInBase(toToken, _feez);\n', '            // addDividend(poolTo, _zz, _feez);\n', '            _transferAmount = _actualYY; outputAmount = _zz; \n', '            fee = _feez + _DAO().UTILS().calcValueInToken(toToken, _feey);\n', '        }\n', '        swapTx += 1;\n', '        _handleTransferOut(toToken, outputAmount, poolTo, msg.sender);\n', '        emit Swapped(fromToken, toToken, _actualAmount, _transferAmount, outputAmount, fee, msg.sender);\n', '        return (outputAmount, fee);\n', '    }\n', '\n', '    function _swapBaseToToken(address payable pool, uint _x) internal returns (uint _y, uint _fee){\n', '        uint _X = Pool_Vether(pool).baseAmt();\n', '        uint _Y = Pool_Vether(pool).tokenAmt();\n', '        _y =  _DAO().UTILS().calcSwapOutput(_x, _X, _Y);\n', '        _fee = _DAO().UTILS().calcSwapFee(_x, _X, _Y);\n', '        Pool_Vether(pool)._setPoolAmounts(_X.add(_x), _Y.sub(_y));\n', '        _updatePoolMetrics(pool, _y+_fee, _fee, false);\n', '        // _checkEmission();\n', '        return (_y, _fee);\n', '    }\n', '\n', '    function _swapTokenToBase(address payable pool, uint _x) internal returns (uint _y, uint _fee){\n', '        uint _X = Pool_Vether(pool).tokenAmt();\n', '        uint _Y = Pool_Vether(pool).baseAmt();\n', '        _y =  _DAO().UTILS().calcSwapOutput(_x, _X, _Y);\n', '        _fee = _DAO().UTILS().calcSwapFee(_x, _X, _Y);\n', '        Pool_Vether(pool)._setPoolAmounts(_Y.sub(_y), _X.add(_x));\n', '        _updatePoolMetrics(pool, _y+_fee, _fee, true);\n', '        // _checkEmission();\n', '        return (_y, _fee);\n', '    }\n', '\n', '    function _updatePoolMetrics(address payable pool, uint _txSize, uint _fee, bool _toBase) internal {\n', '        if(_toBase){\n', '            Pool_Vether(pool)._addPoolMetrics(_txSize, _fee);\n', '        } else {\n', '            uint _txBase = _DAO().UTILS().calcValueInBaseWithPool(pool, _txSize);\n', '            uint _feeBase = _DAO().UTILS().calcValueInBaseWithPool(pool, _fee);\n', '            Pool_Vether(pool)._addPoolMetrics(_txBase, _feeBase);\n', '        }\n', '    }\n', '\n', '\n', '    //==================================================================================//\n', '    // Revenue Functions\n', '\n', '    // Every swap, calculate fee, add to reserve\n', '    // Every era, send reserve to DAO\n', '\n', '    // function _checkEmission() private {\n', '    //     if (now >= nextEraTime) {                                                           // If new Era and allowed to emit\n', '    //         currentEra += 1;                                                               // Increment Era\n', '    //         nextEraTime = now + iBASE(BASE).secondsPerEra() + 100;                     // Set next Era time\n', '    //         uint reserve = iERC20(BASE).balanceOf(address(this));\n', '    //         iERC20(BASE).transfer(address(_DAO()), reserve);\n', '    //         emit NewEra(currentEra, nextEraTime, reserve);                               // Emit Event\n', '    //     }\n', '    // }\n', '\n', '    //==================================================================================//\n', '    // Token Transfer Functions\n', '\n', '    function _handleTransferIn(address _token, uint _amount, address _pool) internal returns(uint actual){\n', '        if(_amount > 0) {\n', '            if(_token == address(0)){\n', '                require((_amount == msg.value), "InputErr");\n', '                payable(_pool).call{value:_amount}(""); \n', '                actual = _amount;\n', '            } else {\n', '                uint startBal = iERC20(_token).balanceOf(_pool); \n', '                iERC20(_token).transferFrom(msg.sender, _pool, _amount); \n', '                actual = iERC20(_token).balanceOf(_pool).sub(startBal);\n', '            }\n', '        }\n', '    }\n', '\n', '    function _handleTransferOut(address _token, uint _amount, address _pool, address payable _recipient) internal {\n', '        if(_amount > 0) {\n', '            if (_token == address(0)) {\n', '                Pool_Vether(payable(_pool)).transferETH(_recipient, _amount);\n', '            } else {\n', '                iERC20(_token).transferFrom(_pool, _recipient, _amount);\n', '            }\n', '        }\n', '    }\n', '\n', '    function _handleTransferOver(address _token, address _from, address _to, uint _amount) internal returns(uint actual){\n', '        if(_amount > 0) {\n', '            uint startBal = iERC20(_token).balanceOf(_to); \n', '            iERC20(_token).transferFrom(_from, _to, _amount); \n', '            actual = iERC20(_token).balanceOf(_to).sub(startBal);\n', '        }\n', '    }\n', '\n', '    //======================================HELPERS========================================//\n', '    // Helper Functions\n', '\n', '    function getPool(address token) public view returns(address payable pool){\n', '        return mapToken_Pool[token];\n', '    }\n', '\n', '    function tokenCount() public view returns(uint){\n', '        return arrayTokens.length;\n', '    }\n', '\n', '    function getToken(uint i) public view returns(address){\n', '        return arrayTokens[i];\n', '    }\n', '\n', '}']