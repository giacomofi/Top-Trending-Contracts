['//SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.4;\n', '\n', '\n', '\n', '/** Website:  https://hydra.finance \n', ' *  Telegram: https://t.me/hydra_f\n', '\n', '\n', '/**\n', ' * Standard SafeMath, stripped down to just add/sub/mul/div\n', ' */\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * ERC20 standard interface.\n', ' */\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function decimals() external view returns (uint8);\n', '\n', '    function symbol() external view returns (string memory);\n', '\n', '    function name() external view returns (string memory);\n', '\n', '    function getOwner() external view returns (address);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    function allowance(address _owner, address spender) external view returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * Allows for contract ownership along with multi-address authorization\n', ' */\n', 'abstract contract Auth {\n', '    address internal owner;\n', '    mapping(address => bool) internal authorizations;\n', '\n', '    constructor(address _owner) {\n', '        owner = _owner;\n', '        authorizations[_owner] = true;\n', '    }\n', '\n', '    /**\n', '     * Function modifier to require caller to be contract owner\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner(msg.sender), "!OWNER");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Function modifier to require caller to be authorized\n', '     */\n', '    modifier authorized() {\n', '        require(isAuthorized(msg.sender), "!AUTHORIZED");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Authorize address. Owner only\n', '     */\n', '    function authorize(address adr) public onlyOwner {\n', '        authorizations[adr] = true;\n', '    }\n', '\n', '    /**\n', "     * Remove address' authorization. Owner only\n", '     */\n', '    function unauthorize(address adr) public onlyOwner {\n', '        authorizations[adr] = false;\n', '    }\n', '\n', '    /**\n', '     * Check if address is owner\n', '     */\n', '    function isOwner(address account) public view returns (bool) {\n', '        return account == owner;\n', '    }\n', '\n', '    /**\n', "     * Return address' authorization status\n", '     */\n', '    function isAuthorized(address adr) public view returns (bool) {\n', '        return authorizations[adr];\n', '    }\n', '\n', '    /**\n', '     * Transfer ownership to new address. Caller must be owner. Leaves old owner authorized\n', '     */\n', '    function transferOwnership(address payable adr) public onlyOwner {\n', '        owner = adr;\n', '        authorizations[adr] = true;\n', '        emit OwnershipTransferred(adr);\n', '    }\n', '\n', '    event OwnershipTransferred(address owner);\n', '}\n', '\n', 'interface IDEXFactory {\n', '    function createPair(address tokenA, address tokenB) external returns (address pair);\n', '}\n', '\n', 'interface IDEXRouter {\n', '    function factory() external pure returns (address);\n', '\n', '    function WETH() external pure returns (address);\n', '\n', '    function addLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint amountADesired,\n', '        uint amountBDesired,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountA, uint amountB, uint liquidity);\n', '\n', '    function addLiquidityETH(\n', '        address token,\n', '        uint amountTokenDesired,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n', '\n', '    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external;\n', '\n', '    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external payable;\n', '\n', '    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external;\n', '}\n', '\n', 'interface IDividendDistributor {\n', '    function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external;\n', '\n', '    function setShare(address shareholder, uint256 amount) external;\n', '\n', '    function deposit() external payable;\n', '\n', '    function process(uint256 gas) external;\n', '}\n', '\n', 'contract DividendDistributor is IDividendDistributor {\n', '    using SafeMath for uint256;\n', '\n', '    address _token;\n', '\n', '    struct Share {\n', '        uint256 amount;\n', '        uint256 totalExcluded;\n', '        uint256 totalRealised;\n', '    }\n', '\n', '    IERC20 USDC = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);\n', '    address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;\n', '    IDEXRouter router;\n', '\n', '    address[] shareholders;\n', '    mapping(address => uint256) shareholderIndexes;\n', '    mapping(address => uint256) shareholderClaims;\n', '    mapping(address => address) shareholderClaimAs;\n', '\n', '    mapping(address => Share) public shares;\n', '\n', '    uint256 public totalShares;\n', '    uint256 public totalDividends;\n', '    uint256 public totalDistributed;\n', '    uint256 public dividendsPerShare;\n', '    uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;\n', '\n', '    uint256 public minPeriod = 1 hours;\n', '    uint256 public minDistribution = 1 * (10 ** 18);\n', '\n', '    uint256 currentIndex;\n', '\n', '    bool initialized;\n', '    modifier initialization() {\n', '        require(!initialized);\n', '        _;\n', '        initialized = true;\n', '    }\n', '\n', '    modifier onlyToken() {\n', '        require(msg.sender == _token);\n', '        _;\n', '    }\n', '\n', '    constructor (address _router) {\n', '        router = _router != address(0)\n', '        ? IDEXRouter(_router)\n', '        : IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n', '        _token = msg.sender;\n', '    }\n', '\n', '    function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external override onlyToken {\n', '        minPeriod = _minPeriod;\n', '        minDistribution = _minDistribution;\n', '    }\n', '\n', '    function setShare(address shareholder, uint256 amount) external override onlyToken {\n', '        if (shares[shareholder].amount > 0) {\n', '            distributeDividend(shareholder);\n', '        }\n', '\n', '        if (amount > 0 && shares[shareholder].amount == 0) {\n', '            addShareholder(shareholder);\n', '        } else if (amount == 0 && shares[shareholder].amount > 0) {\n', '            removeShareholder(shareholder);\n', '        }\n', '\n', '        totalShares = totalShares.sub(shares[shareholder].amount).add(amount);\n', '        shares[shareholder].amount = amount;\n', '        shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);\n', '    }\n', '\n', '    function deposit() external payable override onlyToken {\n', '        uint256 balanceBefore = USDC.balanceOf(address(this));\n', '\n', '        address[] memory path = new address[](2);\n', '        path[0] = WETH;\n', '        path[1] = address(USDC);\n', '\n', '        router.swapExactETHForTokensSupportingFeeOnTransferTokens{value : msg.value}(\n', '            0,\n', '            path,\n', '            address(this),\n', '            block.timestamp\n', '        );\n', '\n', '        uint256 amount = USDC.balanceOf(address(this)).sub(balanceBefore);\n', '\n', '        totalDividends = totalDividends.add(amount);\n', '        dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));\n', '    }\n', '\n', '    function process(uint256 gas) external override onlyToken {\n', '        uint256 shareholderCount = shareholders.length;\n', '\n', '        if (shareholderCount == 0) {return;}\n', '\n', '        uint256 gasUsed = 0;\n', '        uint256 gasLeft = gasleft();\n', '\n', '        uint256 iterations = 0;\n', '\n', '        while (gasUsed < gas && iterations < shareholderCount) {\n', '            if (currentIndex >= shareholderCount) {\n', '                currentIndex = 0;\n', '            }\n', '\n', '            if (shouldDistribute(shareholders[currentIndex])) {\n', '                distributeDividend(shareholders[currentIndex]);\n', '            }\n', '\n', '            gasUsed = gasUsed.add(gasLeft.sub(gasleft()));\n', '            gasLeft = gasleft();\n', '            currentIndex++;\n', '            iterations++;\n', '        }\n', '    }\n', '\n', '    function shouldDistribute(address shareholder) internal view returns (bool) {\n', '        return shareholderClaims[shareholder] + minPeriod < block.timestamp\n', '        && getUnpaidEarnings(shareholder) > minDistribution;\n', '    }\n', '\n', '    function distributeDividend(address shareholder) internal {\n', '        if (shares[shareholder].amount == 0) {return;}\n', '\n', '        uint256 amount = getUnpaidEarnings(shareholder);\n', '        if (amount > 0) {\n', '            totalDistributed = totalDistributed.add(amount);\n', '            swapAndDistributeSpecial(shareholder, amount);\n', '            shareholderClaims[shareholder] = block.timestamp;\n', '            shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);\n', '            shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);\n', '        }\n', '    }\n', '\n', '    function swapAndDistributeSpecial(address shareholder, uint256 amount) internal{\n', '        address claimToken = shareholderClaimAs[shareholder];\n', '        if (claimToken == address(0)) {\n', '            USDC.transfer(shareholder, amount);\n', '        }\n', '        else {\n', '            address[] memory path = new address[](2);\n', '            path[0] = address(USDC);\n', '            path[1] = claimToken;\n', '            try router.swapExactTokensForTokensSupportingFeeOnTransferTokens(amount, 0, path, shareholder, block.timestamp) {} catch{\n', '                USDC.transfer(shareholder, amount);\n', '            }\n', '        }\n', '    }\n', '\n', '    function setClaimAs(address shareholder, address claimtoken) external onlyToken {\n', '        shareholderClaimAs[shareholder] = claimtoken;\n', '    }\n', '\n', '    function getClaimAs(address shareholder) public view onlyToken returns (address) {\n', '        return shareholderClaimAs[shareholder];\n', '    }\n', '\n', '    function claimDividend() external {\n', '        distributeDividend(msg.sender);\n', '    }\n', '\n', '    function getUnpaidEarnings(address shareholder) public view returns (uint256) {\n', '        if (shares[shareholder].amount == 0) {return 0;}\n', '\n', '        uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);\n', '        uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;\n', '\n', '        if (shareholderTotalDividends <= shareholderTotalExcluded) {return 0;}\n', '\n', '        return shareholderTotalDividends.sub(shareholderTotalExcluded);\n', '    }\n', '\n', '    function getCumulativeDividends(uint256 share) internal view returns (uint256) {\n', '        return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);\n', '    }\n', '\n', '    function addShareholder(address shareholder) internal {\n', '        shareholderIndexes[shareholder] = shareholders.length;\n', '        shareholders.push(shareholder);\n', '    }\n', '\n', '    function removeShareholder(address shareholder) internal {\n', '        shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length - 1];\n', '        shareholderIndexes[shareholders[shareholders.length - 1]] = shareholderIndexes[shareholder];\n', '        shareholders.pop();\n', '    }\n', '}\n', '\n', 'contract Hydra is IERC20, Auth {\n', '    using SafeMath for uint256;\n', '\n', '    address USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;\n', '    address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;\n', '    address DEAD = 0x000000000000000000000000000000000000dEaD;\n', '    address ZERO = 0x0000000000000000000000000000000000000000;\n', '\n', '    string constant _name = "Hydra";\n', '    string constant _symbol = "HYDRA";\n', '    uint8 constant _decimals = 9;\n', '\n', '    uint256 _totalSupply = 3000000000000 * (10 ** _decimals);\n', '    uint256 public _maxTxAmount = _totalSupply / 1000; //\n', '\n', '    mapping(address => uint256) _balances;\n', '    mapping(address => mapping(address => uint256)) _allowances;\n', '\n', '    mapping(address => bool) isFeeExempt;\n', '    mapping(address => bool) isTxLimitExempt;\n', '    mapping(address => bool) isDividendExempt;\n', '\n', '    uint256 liquidityFee = 300;\n', '    uint256 buybackFee = 300;\n', '    uint256 reflectionFee = 300;\n', '    uint256 marketingFee = 300;\n', '    uint256 totalFee = 1200;\n', '    uint256 feeDenominator = 10000;\n', '\n', '    address public autoLiquidityReceiver;\n', '    address public marketingFeeReceiver;\n', '\n', '    uint256 targetLiquidity = 25;\n', '    uint256 targetLiquidityDenominator = 100;\n', '\n', '    IDEXRouter public router;\n', '    address public pair;\n', '\n', '    uint256 public launchedAt;\n', '\n', '    uint256 buybackMultiplierNumerator = 200;\n', '    uint256 buybackMultiplierDenominator = 100;\n', '    uint256 buybackMultiplierTriggeredAt;\n', '    uint256 buybackMultiplierLength = 30 minutes;\n', '\n', '    bool public autoBuybackEnabled = false;\n', '    uint256 autoBuybackCap;\n', '    uint256 autoBuybackAccumulator;\n', '    uint256 autoBuybackAmount;\n', '    uint256 autoBuybackBlockPeriod;\n', '    uint256 autoBuybackBlockLast;\n', '\n', '    DividendDistributor distributor;\n', '    uint256 distributorGas = 500000;\n', '\n', '    bool public swapEnabled = true;\n', '    uint256 public swapThreshold = _totalSupply / 20000;\n', '    bool inSwap;\n', '    modifier swapping() {\n', '        inSwap = true;\n', '        _;\n', '        inSwap = false;\n', '    }\n', '\n', '    constructor () Auth(msg.sender) {\n', '        router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n', '        pair = IDEXFactory(router.factory()).createPair(WETH, address(this));\n', '        _allowances[address(this)][address(router)] = uint256(- 1);\n', '\n', '        distributor = new DividendDistributor(address(router));\n', '\n', '        //        isFeeExempt[_presaler] = true;\n', '        //        isTxLimitExempt[_presaler] = true;\n', '\n', '        //        isFeeExempt[_presaleContract] = true;\n', '        //        isTxLimitExempt[_presaleContract] = true;\n', '        //        isDividendExempt[_presaleContract] = true;\n', '\n', '        isDividendExempt[pair] = true;\n', '        isDividendExempt[address(this)] = true;\n', '\n', '        autoLiquidityReceiver = msg.sender;\n', '        marketingFeeReceiver = msg.sender;\n', '\n', '        _balances[msg.sender] = _totalSupply;\n', '        emit Transfer(address(0), msg.sender, _totalSupply);\n', '    }\n', '\n', '    receive() external payable {}\n', '\n', '    function totalSupply() external view override returns (uint256) {return _totalSupply;}\n', '\n', '    function decimals() external pure override returns (uint8) {return _decimals;}\n', '\n', '    function symbol() external pure override returns (string memory) {return _symbol;}\n', '\n', '    function name() external pure override returns (string memory) {return _name;}\n', '\n', '    function getOwner() external view override returns (address) {return owner;}\n', '\n', '    function balanceOf(address account) public view override returns (uint256) {return _balances[account];}\n', '\n', '    function allowance(address holder, address spender) external view override returns (uint256) {return _allowances[holder][spender];}\n', '\n', '    function approve(address spender, uint256 amount) public override returns (bool) {\n', '        _allowances[msg.sender][spender] = amount;\n', '        emit Approval(msg.sender, spender, amount);\n', '        return true;\n', '    }\n', '\n', '    function approveMax(address spender) external returns (bool) {\n', '        return approve(spender, uint256(- 1));\n', '    }\n', '\n', '    function transfer(address recipient, uint256 amount) external override returns (bool) {\n', '        return _transferFrom(msg.sender, recipient, amount);\n', '    }\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {\n', '        if (_allowances[sender][msg.sender] != uint256(- 1)) {\n', '            _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");\n', '        }\n', '\n', '        return _transferFrom(sender, recipient, amount);\n', '    }\n', '\n', '    function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {\n', '        if (inSwap) {return _basicTransfer(sender, recipient, amount);}\n', '\n', '        checkTxLimit(sender, amount);\n', '\n', '        if (shouldSwapBack()) {swapBack();}\n', '        if (shouldAutoBuyback()) {triggerAutoBuyback();}\n', '\n', '        if(!launched() && recipient == pair){ require(_balances[sender] > 0); launch(); }\n', '\n', '        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");\n', '\n', '        uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, recipient, amount) : amount;\n', '        _balances[recipient] = _balances[recipient].add(amountReceived);\n', '\n', '        if (!isDividendExempt[sender]) {try distributor.setShare(sender, _balances[sender]) {} catch {}}\n', '        if (!isDividendExempt[recipient]) {try distributor.setShare(recipient, _balances[recipient]) {} catch {}}\n', '\n', '        try distributor.process(distributorGas) {} catch {}\n', '\n', '        emit Transfer(sender, recipient, amountReceived);\n', '        return true;\n', '    }\n', '\n', '    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {\n', '        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    function checkTxLimit(address sender, uint256 amount) internal view {\n', '        require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");\n', '    }\n', '\n', '    function shouldTakeFee(address sender) internal view returns (bool) {\n', '        return !isFeeExempt[sender];\n', '    }\n', '\n', '    function getTotalFee(bool selling) public view returns (uint256) {\n', '        if (launchedAt + 1 >= block.number) {return feeDenominator.sub(1);}\n', '        if(selling && buybackMultiplierTriggeredAt.add(buybackMultiplierLength) > block.timestamp){ return getMultipliedFee(); }\n', '        return totalFee;\n', '    }\n', '\n', '    function getMultipliedFee() public view returns (uint256) {\n', '        uint256 remainingTime = buybackMultiplierTriggeredAt.add(buybackMultiplierLength).sub(block.timestamp);\n', '        uint256 feeIncrease = totalFee.mul(buybackMultiplierNumerator).div(buybackMultiplierDenominator).sub(totalFee);\n', '        return totalFee.add(feeIncrease.mul(remainingTime).div(buybackMultiplierLength));\n', '    }\n', '\n', '    function takeFee(address sender, address receiver, uint256 amount) internal returns (uint256) {\n', '        uint256 feeAmount = amount.mul(getTotalFee(receiver == pair)).div(feeDenominator);\n', '\n', '        _balances[address(this)] = _balances[address(this)].add(feeAmount);\n', '        emit Transfer(sender, address(this), feeAmount);\n', '\n', '        return amount.sub(feeAmount);\n', '    }\n', '\n', '    function shouldSwapBack() internal view returns (bool) {\n', '        return msg.sender != pair\n', '        && !inSwap\n', '        && swapEnabled\n', '        && _balances[address(this)] >= swapThreshold;\n', '    }\n', '\n', '    function swapBack() internal swapping {\n', '        uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;\n', '        uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);\n', '        uint256 amountToSwap = swapThreshold.sub(amountToLiquify);\n', '\n', '        address[] memory path = new address[](2);\n', '        path[0] = address(this);\n', '        path[1] = WETH;\n', '\n', '        uint256 balanceBefore = address(this).balance;\n', '\n', '        router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n', '            amountToSwap,\n', '            0,\n', '            path,\n', '            address(this),\n', '            block.timestamp\n', '        );\n', '\n', '        uint256 amountETH = address(this).balance.sub(balanceBefore);\n', '\n', '        uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));\n', '\n', '        uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);\n', '        uint256 amountETHReflection = amountETH.mul(reflectionFee).div(totalETHFee);\n', '        uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);\n', '\n', '        try distributor.deposit{value : amountETHReflection}() {} catch {}\n', '        payable(marketingFeeReceiver).call{value : amountETHMarketing, gas : 30000}("");\n', '\n', '        if (amountToLiquify > 0) {\n', '            router.addLiquidityETH{value : amountETHLiquidity}(\n', '                address(this),\n', '                amountToLiquify,\n', '                0,\n', '                0,\n', '                autoLiquidityReceiver,\n', '                block.timestamp\n', '            );\n', '            emit AutoLiquify(amountETHLiquidity, amountToLiquify);\n', '        }\n', '    }\n', '\n', '    function shouldAutoBuyback() internal view returns (bool) {\n', '        return msg.sender != pair\n', '        && !inSwap\n', '        && autoBuybackEnabled\n', '        && autoBuybackBlockLast + autoBuybackBlockPeriod <= block.number\n', '        && address(this).balance >= autoBuybackAmount;\n', '    }\n', '\n', '    function triggerHydraBuyback(uint256 amount, bool triggerBuybackMultiplier) external authorized {\n', '        buyTokens(amount, DEAD);\n', '        if (triggerBuybackMultiplier) {\n', '            buybackMultiplierTriggeredAt = block.timestamp;\n', '            emit BuybackMultiplierActive(buybackMultiplierLength);\n', '        }\n', '    }\n', '\n', '    function clearBuybackMultiplier() external authorized {\n', '        buybackMultiplierTriggeredAt = 0;\n', '    }\n', '\n', '    function triggerAutoBuyback() internal {\n', '        buyTokens(autoBuybackAmount, DEAD);\n', '        autoBuybackBlockLast = block.number;\n', '        autoBuybackAccumulator = autoBuybackAccumulator.add(autoBuybackAmount);\n', '        if (autoBuybackAccumulator > autoBuybackCap) {autoBuybackEnabled = false;}\n', '    }\n', '\n', '    function buyTokens(uint256 amount, address to) internal swapping {\n', '        address[] memory path = new address[](2);\n', '        path[0] = WETH;\n', '        path[1] = address(this);\n', '\n', '        router.swapExactETHForTokensSupportingFeeOnTransferTokens{value : amount}(\n', '            0,\n', '            path,\n', '            to,\n', '            block.timestamp\n', '        );\n', '    }\n', '\n', '    function setAutoBuybackSettings(bool _enabled, uint256 _cap, uint256 _amount, uint256 _period) external authorized {\n', '        autoBuybackEnabled = _enabled;\n', '        autoBuybackCap = _cap;\n', '        autoBuybackAccumulator = 0;\n', '        autoBuybackAmount = _amount;\n', '        autoBuybackBlockPeriod = _period;\n', '        autoBuybackBlockLast = block.number;\n', '    }\n', '\n', '    function setBuybackMultiplierSettings(uint256 numerator, uint256 denominator, uint256 length) external authorized {\n', '        require(numerator / denominator <= 2 && numerator > denominator);\n', '        buybackMultiplierNumerator = numerator;\n', '        buybackMultiplierDenominator = denominator;\n', '        buybackMultiplierLength = length;\n', '    }\n', '\n', '    function launched() internal view returns (bool) {\n', '        return launchedAt != 0;\n', '    }\n', '\n', '    function launch() internal {\n', '        launchedAt = block.number;\n', '    }\n', '\n', '    function setTxLimit(uint256 amount) external authorized {\n', '        require(amount >= _totalSupply / 1000);\n', '        _maxTxAmount = amount;\n', '    }\n', '\n', '    function setIsDividendExempt(address holder, bool exempt) external authorized {\n', '        require(holder != address(this) && holder != pair);\n', '        isDividendExempt[holder] = exempt;\n', '        if (exempt) {\n', '            distributor.setShare(holder, 0);\n', '        } else {\n', '            distributor.setShare(holder, _balances[holder]);\n', '        }\n', '    }\n', '\n', '    function setIsFeeExempt(address holder, bool exempt) external authorized {\n', '        isFeeExempt[holder] = exempt;\n', '    }\n', '\n', '    function setIsTxLimitExempt(address holder, bool exempt) external authorized {\n', '        isTxLimitExempt[holder] = exempt;\n', '    }\n', '\n', '    function setFees(uint256 _liquidityFee, uint256 _buybackFee, uint256 _reflectionFee, uint256 _marketingFee, uint256 _feeDenominator) external authorized {\n', '        liquidityFee = _liquidityFee;\n', '        buybackFee = _buybackFee;\n', '        reflectionFee = _reflectionFee;\n', '        marketingFee = _marketingFee;\n', '        totalFee = _liquidityFee.add(_buybackFee).add(_reflectionFee).add(_marketingFee);\n', '        feeDenominator = _feeDenominator;\n', '        require(totalFee < feeDenominator / 4);\n', '    }\n', '\n', '    function setFeeReceivers(address _autoLiquidityReceiver, address _marketingFeeReceiver) external authorized {\n', '        autoLiquidityReceiver = _autoLiquidityReceiver;\n', '        marketingFeeReceiver = _marketingFeeReceiver;\n', '    }\n', '\n', '    function setSwapBackSettings(bool _enabled, uint256 _amount) external authorized {\n', '        swapEnabled = _enabled;\n', '        swapThreshold = _amount;\n', '    }\n', '\n', '    function setTargetLiquidity(uint256 _target, uint256 _denominator) external authorized {\n', '        targetLiquidity = _target;\n', '        targetLiquidityDenominator = _denominator;\n', '    }\n', '\n', '    function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external authorized {\n', '        distributor.setDistributionCriteria(_minPeriod, _minDistribution);\n', '    }\n', '\n', '    function setDistributorSettings(uint256 gas) external authorized {\n', '        require(gas < 750000);\n', '        distributorGas = gas;\n', '    }\n', '\n', '    function setClaimAs(address claimAs) external {\n', '        distributor.setClaimAs(msg.sender, claimAs);\n', '    }\n', '\n', '    function getClaimAs() public view returns (address) {\n', '       return distributor.getClaimAs(msg.sender);\n', '    }\n', '\n', '    function getCirculatingSupply() public view returns (uint256) {\n', '        return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));\n', '    }\n', '\n', '    function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {\n', '        return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());\n', '    }\n', '\n', '    function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {\n', '        return getLiquidityBacking(accuracy) > target;\n', '    }\n', '\n', '    event AutoLiquify(uint256 amountETH, uint256 amountBOG);\n', '    event BuybackMultiplierActive(uint256 duration);\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  }\n', '}']