['pragma solidity ^0.5.7;\n', '\n', '\n', '// Token Public Sale\n', '\n', 'library SafeMath256 {\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b > 0);\n', '        uint256 c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return a / b;\n', '    }\n', '\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', 'library SafeMath16 {\n', '\n', '    function add(uint16 a, uint16 b) internal pure returns (uint16 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '\n', '    function sub(uint16 a, uint16 b) internal pure returns (uint16) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function mul(uint16 a, uint16 b) internal pure returns (uint16 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint16 a, uint16 b) internal pure returns (uint16) {\n', '        assert(b > 0);\n', '        uint256 c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return a / b;\n', '    }\n', '\n', '    function mod(uint16 a, uint16 b) internal pure returns (uint16) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', 'contract Ownable {\n', '    address private _owner;\n', '    address payable internal _receiver;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    event ReceiverChanged(address indexed previousReceiver, address indexed newReceiver);\n', '\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        _receiver = msg.sender;\n', '    }\n', '\n', '\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == _owner);\n', '        _;\n', '    }\n', '\n', '\n', '    function transferOwnership(address newOwner) external onlyOwner {\n', '        require(newOwner != address(0));\n', '        address __previousOwner = _owner;\n', '        _owner = newOwner;\n', '        emit OwnershipTransferred(__previousOwner, newOwner);\n', '    }\n', '\n', '    function changeReceiver(address payable newReceiver) external onlyOwner {\n', '        require(newReceiver != address(0));\n', '        address __previousReceiver = _receiver;\n', '        _receiver = newReceiver;\n', '        emit ReceiverChanged(__previousReceiver, newReceiver);\n', '    }\n', '\n', '    function rescueTokens(address tokenAddress, address receiver, uint256 amount) external onlyOwner {\n', '        IERC20 _token = IERC20(tokenAddress);\n', '        require(receiver != address(0));\n', '        uint256 balance = _token.balanceOf(address(this));\n', '        require(balance >= amount);\n', '\n', '        assert(_token.transfer(receiver, amount));\n', '    }\n', '\n', '\n', '    function withdrawEther(address payable to, uint256 amount) external onlyOwner {\n', '        require(to != address(0));\n', '        uint256 balance = address(this).balance;\n', '        require(balance >= amount);\n', '\n', '        to.transfer(amount);\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract Pausable is Ownable {\n', '    bool private _paused;\n', '\n', '    event Paused(address account);\n', '    event Unpaused(address account);\n', '\n', '    constructor () internal {\n', '        _paused = false;\n', '    }\n', '\n', '    function paused() public view returns (bool) {\n', '        return _paused;\n', '    }\n', '\n', '    modifier whenNotPaused() {\n', '        require(!_paused, "Paused.");\n', '        _;\n', '    }\n', '\n', '    function setPaused(bool state) external onlyOwner {\n', '        if (_paused && !state) {\n', '            _paused = false;\n', '            emit Unpaused(msg.sender);\n', '        } else if (!_paused && state) {\n', '            _paused = true;\n', '            emit Paused(msg.sender);\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'interface IERC20 {\n', '    function balanceOf(address owner) external view returns (uint256);\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '}\n', '\n', '\n', 'interface IToken {\n', '    function balanceOf(address owner) external view returns (uint256);\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '    function inWhitelist(address account) external view returns (bool);\n', '    function referrer(address account) external view returns (address);\n', '    function refCount(address account) external view returns (uint256);\n', '}\n', '\n', '\n', 'contract TokenPublicSale is Ownable, Pausable{\n', '    using SafeMath16 for uint16;\n', '    using SafeMath256 for uint256;\n', '\n', '    IToken public TOKEN = IToken(0xfaCe8492ce3EE56855827b5eC3f9Affd0a4c5E15);\n', '\n', '    // Start timestamp\n', '    uint32 _startTimestamp;\n', '\n', '    // Audit ether price\n', '    uint256 private _etherPrice;    // 1 Ether = xx.xxxxxx USD, with 6 decimals\n', '\n', '    // Referral rewards, 35% for 15 levels\n', '    uint16 private WHITELIST_REF_REWARDS_PCT_SUM = 35;\n', '    uint16[15] private WHITELIST_REF_REWARDS_PCT = [\n', '    6,  // 6% for Level.1\n', '    6,  // 6% for Level.2\n', '    5,  // 5% for Level.3\n', '    4,  // 4% for Level.4\n', '    3,  // 3% for Level.5\n', '    2,  // 2% for Level.6\n', '    1,  // 1% for Level.7\n', '    1,  // 1% for Level.8\n', '    1,  // 1% for Level.9\n', '    1,  // 1% for Level.10\n', '    1,  // 1% for Level.11\n', '    1,  // 1% for Level.12\n', '    1,  // 1% for Level.13\n', '    1,  // 1% for Level.14\n', '    1   // 1% for Level.15\n', '    ];\n', '\n', '    // Wei & Gas\n', '    uint72 private WEI_MIN   = 0.1 ether;      // 0.1 Ether Minimum\n', '    uint72 private WEI_MAX   = 10 ether;       // 10 Ether Maximum\n', '    uint72 private WEI_BONUS = 10 ether;       // >10 Ether for Bonus\n', '    uint24 private GAS_MIN   = 3000000;        // 3.0 Mwei gas Mininum\n', '    uint24 private GAS_EX    = 1500000;        // 1.5 Mwei gas for ex\n', '\n', '    // Price\n', '    uint256 private TOKEN_USD_PRICE_START = 1000;           // $      0.00100 USD\n', '    uint256 private TOKEN_USD_PRICE_STEP  = 10;             // $    + 0.00001 USD\n', '    uint256 private STAGE_USD_CAP_START   = 100000000;      // $    100 USD\n', '    uint256 private STAGE_USD_CAP_STEP    = 1000000;        // $     +1 USD\n', '    uint256 private STAGE_USD_CAP_MAX     = 15100000000;    // $    15,100 USD\n', '\n', '    uint256 private _tokenUsdPrice        = TOKEN_USD_PRICE_START;\n', '\n', '    // Progress\n', '    uint16 private STAGE_MAX = 60000;   // 60,000 stages total\n', '    uint16 private SEASON_MAX = 100;    // 100 seasons total\n', '    uint16 private SEASON_STAGES = 600; // each 600 stages is a season\n', '\n', '    uint16 private _stage;\n', '    uint16 private _season;\n', '\n', '    // Sum\n', '    uint256 private _txs;\n', '    uint256 private _tokenTxs;\n', '    uint256 private _tokenBonusTxs;\n', '    uint256 private _tokenWhitelistTxs;\n', '    uint256 private _tokenIssued;\n', '    uint256 private _tokenBonus;\n', '    uint256 private _tokenWhitelist;\n', '    uint256 private _weiSold;\n', '    uint256 private _weiRefRewarded;\n', '    uint256 private _weiTopSales;\n', '    uint256 private _weiTeam;\n', '    uint256 private _weiPending;\n', '    uint256 private _weiPendingTransfered;\n', '\n', '    // Top-Sales\n', '    uint256 private TOP_SALES_RATIO_START = 15000000;         // 15%, with 8 decimals\n', '    uint256 private TOP_SALES_RATIO_DISTANCE = 50000000;      // 50%, with 8 decimals\n', '\n', '    uint256 private _topSalesRatio = TOP_SALES_RATIO_START;   // 15% + 50% x(_stage/_stageMax)\n', '\n', '    // During tx\n', '    bool private _inWhitelist_;\n', '    uint256 private _pending_ = WHITELIST_REF_REWARDS_PCT_SUM;\n', '    uint16[] private _rewards_;\n', '    address[] private _referrers_;\n', '\n', '    // Audit ether price auditor\n', '    mapping (address => bool) private _etherPriceAuditors;\n', '\n', '    // Stage\n', '    mapping (uint16 => uint256) private _stageUsdSold;\n', '    mapping (uint16 => uint256) private _stageTokenIssued;\n', '\n', '    // Season\n', '    mapping (uint16 => uint256) private _seasonWeiSold;\n', '    mapping (uint16 => uint256) private _seasonWeiTopSales;\n', '    mapping (uint16 => uint256) private _seasonWeiTopSalesTransfered;\n', '\n', '    // Account\n', '    mapping (address => uint256) private _accountTokenIssued;\n', '    mapping (address => uint256) private _accountTokenBonus;\n', '    mapping (address => uint256) private _accountTokenWhitelisted;\n', '    mapping (address => uint256) private _accountWeiPurchased;\n', '    mapping (address => uint256) private _accountWeiRefRewarded;\n', '\n', '    // Ref\n', '    mapping (uint16 => address[]) private _seasonRefAccounts;\n', '    mapping (uint16 => mapping (address => bool)) private _seasonHasRefAccount;\n', '    mapping (uint16 => mapping (address => uint256)) private _usdSeasonAccountPurchased;\n', '    mapping (uint16 => mapping (address => uint256)) private _usdSeasonAccountRef;\n', '\n', '    // Events\n', '    event AuditEtherPriceChanged(uint256 value, address indexed account);\n', '    event AuditEtherPriceAuditorChanged(address indexed account, bool state);\n', '\n', '    event TokenBonusTransfered(address indexed to, uint256 amount);\n', '    event TokenWhitelistTransfered(address indexed to, uint256 amount);\n', '    event TokenIssuedTransfered(uint16 stageIndex, address indexed to, uint256 tokenAmount, uint256 auditEtherPrice, uint256 weiUsed);\n', '\n', '    event StageClosed(uint256 _stageNumber, address indexed account);\n', '    event SeasonClosed(uint16 _seasonNumber, address indexed account);\n', '\n', '    event SeasonTopSalesWeiTransfered(uint16 seasonNumber, address indexed to, uint256 amount);\n', '    event TeamWeiTransfered(address indexed to, uint256 amount);\n', '    event PendingWeiTransfered(address indexed to, uint256 amount);\n', '\n', '\n', '    function startTimestamp() public view returns (uint32) {\n', '        return _startTimestamp;\n', '    }\n', '\n', '    function setStartTimestamp(uint32 timestamp) external onlyOwner {\n', '        _startTimestamp = timestamp;\n', '    }\n', '\n', '    modifier onlyEtherPriceAuditor() {\n', '        require(_etherPriceAuditors[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    function setEtherPrice(uint256 value) external onlyEtherPriceAuditor {\n', '        _etherPrice = value;\n', '        emit AuditEtherPriceChanged(value, msg.sender);\n', '    }\n', '\n', '    function etherPriceAuditor(address account) public view returns (bool) {\n', '        return _etherPriceAuditors[account];\n', '    }\n', '\n', '    function setEtherPriceAuditor(address account, bool state) external onlyOwner {\n', '        _etherPriceAuditors[account] = state;\n', '        emit AuditEtherPriceAuditorChanged(account, state);\n', '    }\n', '\n', '    function stageTokenUsdPrice(uint16 stageIndex) private view returns (uint256) {\n', '        return TOKEN_USD_PRICE_START.add(TOKEN_USD_PRICE_STEP.mul(stageIndex));\n', '    }\n', '\n', '    function wei2usd(uint256 amount) private view returns (uint256) {\n', '        return amount.mul(_etherPrice).div(1 ether);\n', '    }\n', '\n', '    function usd2wei(uint256 amount) private view returns (uint256) {\n', '        return amount.mul(1 ether).div(_etherPrice);\n', '    }\n', '\n', '    function usd2token(uint256 usdAmount) private view returns (uint256) {\n', '        return usdAmount.mul(1000000).div(_tokenUsdPrice);\n', '    }\n', '\n', '    function usd2tokenByStage(uint256 usdAmount, uint16 stageIndex) public view returns (uint256) {\n', '        return usdAmount.mul(1000000).div(stageTokenUsdPrice(stageIndex));\n', '    }\n', '\n', '    function calcSeason(uint16 stageIndex) private view returns (uint16) {\n', '        if (stageIndex > 0) {\n', '            uint16 __seasonNumber = stageIndex.div(SEASON_STAGES);\n', '\n', '            if (stageIndex.mod(SEASON_STAGES) > 0) {\n', '                return __seasonNumber.add(1);\n', '            }\n', '\n', '            return __seasonNumber;\n', '        }\n', '\n', '        return 1;\n', '    }\n', '\n', '\n', '    function transferTopSales(uint16 seasonNumber, address payable to) external onlyOwner {\n', '        uint256 __weiRemain = seasonTopSalesRemain(seasonNumber);\n', '        require(to != address(0));\n', '\n', '        _seasonWeiTopSalesTransfered[seasonNumber] = _seasonWeiTopSalesTransfered[seasonNumber].add(__weiRemain);\n', '        emit SeasonTopSalesWeiTransfered(seasonNumber, to, __weiRemain);\n', '        to.transfer(__weiRemain);\n', '    }\n', '\n', '    function pendingRemain() private view returns (uint256) {\n', '        return _weiPending.sub(_weiPendingTransfered);\n', '    }\n', '\n', '\n', '    function transferPending(address payable to) external onlyOwner {\n', '        uint256 __weiRemain = pendingRemain();\n', '        require(to != address(0));\n', '\n', '        _weiPendingTransfered = _weiPendingTransfered.add(__weiRemain);\n', '        emit PendingWeiTransfered(to, __weiRemain);\n', '        to.transfer(__weiRemain);\n', '    }\n', '\n', '    function transferTeam(address payable to) external onlyOwner {\n', '        uint256 __weiRemain = _weiSold.sub(_weiRefRewarded).sub(_weiTopSales).sub(_weiPending).sub(_weiTeam);\n', '        require(to != address(0));\n', '\n', '        _weiTeam = _weiTeam.add(__weiRemain);\n', '        emit TeamWeiTransfered(to, __weiRemain);\n', '        to.transfer(__weiRemain);\n', '    }\n', '\n', '\n', '    function status() public view returns (uint256 auditEtherPrice,\n', '        uint16 stage,\n', '        uint16 season,\n', '        uint256 tokenUsdPrice,\n', '        uint256 currentTopSalesRatio,\n', '        uint256 txs,\n', '        uint256 tokenTxs,\n', '        uint256 tokenBonusTxs,\n', '        uint256 tokenWhitelistTxs,\n', '        uint256 tokenIssued,\n', '        uint256 tokenBonus,\n', '        uint256 tokenWhitelist) {\n', '        auditEtherPrice = _etherPrice;\n', '\n', '        if (_stage > STAGE_MAX) {\n', '            stage = STAGE_MAX;\n', '            season = SEASON_MAX;\n', '        } else {\n', '            stage = _stage;\n', '            season = _season;\n', '        }\n', '\n', '        tokenUsdPrice = _tokenUsdPrice;\n', '        currentTopSalesRatio = _topSalesRatio;\n', '\n', '        txs = _txs;\n', '        tokenTxs = _tokenTxs;\n', '        tokenBonusTxs = _tokenBonusTxs;\n', '        tokenWhitelistTxs = _tokenWhitelistTxs;\n', '        tokenIssued = _tokenIssued;\n', '        tokenBonus = _tokenBonus;\n', '        tokenWhitelist = _tokenWhitelist;\n', '    }\n', '\n', '    function sum() public view returns(uint256 weiSold,\n', '        uint256 weiReferralRewarded,\n', '        uint256 weiTopSales,\n', '        uint256 weiTeam,\n', '        uint256 weiPending,\n', '        uint256 weiPendingTransfered,\n', '        uint256 weiPendingRemain) {\n', '        weiSold = _weiSold;\n', '        weiReferralRewarded = _weiRefRewarded;\n', '        weiTopSales = _weiTopSales;\n', '        weiTeam = _weiTeam;\n', '        weiPending = _weiPending;\n', '        weiPendingTransfered = _weiPendingTransfered;\n', '        weiPendingRemain = pendingRemain();\n', '    }\n', '\n', '    modifier enoughGas() {\n', '        require(gasleft() > GAS_MIN);\n', '        _;\n', '    }\n', '\n', '    modifier onlyOnSale() {\n', '        require(_startTimestamp > 0 && now > _startTimestamp, "TM Token Public-Sale has not started yet.");\n', '        require(_etherPrice > 0,        "Audit ETH price must be greater than zero.");\n', '        require(!paused(),              "TM Token Public-Sale is paused.");\n', '        require(_stage <= STAGE_MAX,    "TM Token Public-Sale Closed.");\n', '        _;\n', '    }\n', '\n', '\n', '    function topSalesRatio(uint16 stageIndex) private view returns (uint256) {\n', '        return TOP_SALES_RATIO_START.add(TOP_SALES_RATIO_DISTANCE.mul(stageIndex).div(STAGE_MAX));\n', '    }\n', '\n', '    function usd2weiTopSales(uint256 usdAmount) private view returns (uint256) {\n', '        return usd2wei(usdAmount.mul(_topSalesRatio).div(100000000));\n', '    }\n', '\n', '\n', '    function stageUsdCap(uint16 stageIndex) private view returns (uint256) {\n', '        uint256 __usdCap = STAGE_USD_CAP_START.add(STAGE_USD_CAP_STEP.mul(stageIndex));\n', '\n', '        if (__usdCap > STAGE_USD_CAP_MAX) {\n', '            return STAGE_USD_CAP_MAX;\n', '        }\n', '\n', '        return __usdCap;\n', '    }\n', '\n', '\n', '    function stageTokenCap(uint16 stageIndex) private view returns (uint256) {\n', '        return usd2tokenByStage(stageUsdCap(stageIndex), stageIndex);\n', '    }\n', '\n', '\n', '    function stageStatus(uint16 stageIndex) public view returns (uint256 tokenUsdPrice,\n', '        uint256 tokenCap,\n', '        uint256 tokenOnSale,\n', '        uint256 tokenSold,\n', '        uint256 usdCap,\n', '        uint256 usdOnSale,\n', '        uint256 usdSold,\n', '        uint256 weiTopSalesRatio) {\n', '        if (stageIndex > STAGE_MAX) {\n', '            return (0, 0, 0, 0, 0, 0, 0, 0);\n', '        }\n', '\n', '        tokenUsdPrice = stageTokenUsdPrice(stageIndex);\n', '\n', '        tokenSold = _stageTokenIssued[stageIndex];\n', '        tokenCap = stageTokenCap(stageIndex);\n', '        tokenOnSale = tokenCap.sub(tokenSold);\n', '\n', '        usdSold = _stageUsdSold[stageIndex];\n', '        usdCap = stageUsdCap(stageIndex);\n', '        usdOnSale = usdCap.sub(usdSold);\n', '\n', '        weiTopSalesRatio = topSalesRatio(stageIndex);\n', '    }\n', '\n', '    function seasonTopSalesRemain(uint16 seasonNumber) private view returns (uint256) {\n', '        return _seasonWeiTopSales[seasonNumber].sub(_seasonWeiTopSalesTransfered[seasonNumber]);\n', '    }\n', '\n', '    function seasonTopSalesRewards(uint16 seasonNumber) public view returns (uint256 weiSold,\n', '        uint256 weiTopSales,\n', '        uint256 weiTopSalesTransfered,\n', '        uint256 weiTopSalesRemain) {\n', '        weiSold = _seasonWeiSold[seasonNumber];\n', '        weiTopSales = _seasonWeiTopSales[seasonNumber];\n', '        weiTopSalesTransfered = _seasonWeiTopSalesTransfered[seasonNumber];\n', '        weiTopSalesRemain = seasonTopSalesRemain(seasonNumber);\n', '    }\n', '\n', '    function accountQuery(address account) public view returns (uint256 tokenIssued,\n', '        uint256 tokenBonus,\n', '        uint256 tokenWhitelisted,\n', '        uint256 weiPurchased,\n', '        uint256 weiReferralRewarded) {\n', '        tokenIssued = _accountTokenIssued[account];\n', '        tokenBonus = _accountTokenBonus[account];\n', '        tokenWhitelisted = _accountTokenWhitelisted[account];\n', '        weiPurchased = _accountWeiPurchased[account];\n', '        weiReferralRewarded = _accountWeiRefRewarded[account];\n', '    }\n', '\n', '    function seasonRefAccounts(uint16 seasonNumber) public view returns (address[] memory accounts) {\n', '        accounts = _seasonRefAccounts[seasonNumber];\n', '    }\n', '\n', '    function usdSeasonAccountPurchased(uint16 seasonNumber, address account) public view returns (uint256) {\n', '        return _usdSeasonAccountPurchased[seasonNumber][account];\n', '    }\n', '\n', '    function usdSeasonAccountRef(uint16 seasonNumber, address account) public view returns (uint256) {\n', '        return _usdSeasonAccountRef[seasonNumber][account];\n', '    }\n', '\n', '    constructor () public {\n', '        _etherPriceAuditors[msg.sender] = true;\n', '        _stage = 0;\n', '        _season = 1;\n', '    }\n', '\n', '    function () external payable enoughGas onlyOnSale {\n', '        require(msg.value >= WEI_MIN);\n', '        require(msg.value <= WEI_MAX);\n', '\n', '        // Set temporary variables.\n', '        setTemporaryVariables();\n', '        uint256 __usdAmount = wei2usd(msg.value);\n', '        uint256 __usdRemain = __usdAmount;\n', '        uint256 __tokenIssued;\n', '        uint256 __tokenBonus;\n', '        uint256 __usdUsed;\n', '        uint256 __weiUsed;\n', '\n', '        // USD => TM Token\n', '        while (gasleft() > GAS_EX && __usdRemain > 0 && _stage <= STAGE_MAX) {\n', '            uint256 __txTokenIssued;\n', '            (__txTokenIssued, __usdRemain) = ex(__usdRemain);\n', '            __tokenIssued = __tokenIssued.add(__txTokenIssued);\n', '        }\n', '\n', '        // Used\n', '        __usdUsed = __usdAmount.sub(__usdRemain);\n', '        __weiUsed = usd2wei(__usdUsed);\n', '\n', '        // Bonus 10%\n', '        if (msg.value >= WEI_BONUS) {\n', '            __tokenBonus = __tokenIssued.div(10);\n', '            assert(transferTokenBonus(__tokenBonus));\n', '        }\n', '\n', '        // Whitelisted\n', '        // BUY-ONE-AND-GET-ONE-MORE-FREE\n', '        if (_inWhitelist_ && __tokenIssued > 0) {\n', '            // both issued and bonus\n', '            assert(transferTokenWhitelisted(__tokenIssued.add(__tokenBonus)));\n', '\n', '            // 35% for 15 levels\n', '            sendWhitelistReferralRewards(__weiUsed);\n', '        }\n', '\n', '        // If wei remains, refund.\n', '        if (__usdRemain > 0) {\n', '            uint256 __weiRemain = usd2wei(__usdRemain);\n', '\n', '            __weiUsed = msg.value.sub(__weiRemain);\n', '\n', '            // Refund wei back\n', '            msg.sender.transfer(__weiRemain);\n', '        }\n', '\n', '        // Counter\n', '        if (__weiUsed > 0) {\n', '            _txs = _txs.add(1);\n', '            _weiSold = _weiSold.add(__weiUsed);\n', '            _accountWeiPurchased[msg.sender] = _accountWeiPurchased[msg.sender].add(__weiUsed);\n', '        }\n', '\n', '        // Wei team\n', '        uint256 __weiTeam;\n', '        if (_season > SEASON_MAX)\n', '            __weiTeam = _weiSold.sub(_weiRefRewarded).sub(_weiTopSales).sub(_weiPending).sub(_weiTeam);\n', '        else\n', '            __weiTeam = _weiSold.sub(_weiRefRewarded).sub(_weiTopSales).sub(_weiPending).sub(_weiTeam).div(0.01 ether).mul(0.01 ether);\n', '\n', '        _weiTeam = _weiTeam.add(__weiTeam);\n', '        _receiver.transfer(__weiTeam);\n', '\n', '        // Assert finished\n', '        assert(true);\n', '    }\n', '\n', '    function setTemporaryVariables() private {\n', '        delete _referrers_;\n', '        delete _rewards_;\n', '\n', '        _inWhitelist_ = TOKEN.inWhitelist(msg.sender);\n', '        _pending_ = WHITELIST_REF_REWARDS_PCT_SUM;\n', '\n', '        address __cursor = msg.sender;\n', '        for(uint16 i = 0; i < WHITELIST_REF_REWARDS_PCT.length; i++) {\n', '            address __refAccount = TOKEN.referrer(__cursor);\n', '\n', '            if (__cursor == __refAccount)\n', '                break;\n', '\n', '            if (TOKEN.refCount(__refAccount) > i) {\n', '                if (!_seasonHasRefAccount[_season][__refAccount]) {\n', '                    _seasonRefAccounts[_season].push(__refAccount);\n', '                    _seasonHasRefAccount[_season][__refAccount] = true;\n', '                }\n', '\n', '                _pending_ = _pending_.sub(WHITELIST_REF_REWARDS_PCT[i]);\n', '                _rewards_.push(WHITELIST_REF_REWARDS_PCT[i]);\n', '                _referrers_.push(__refAccount);\n', '            }\n', '\n', '            __cursor = __refAccount;\n', '        }\n', '    }\n', '\n', '    /**\n', '     *  USD => TM Token\n', '     */\n', '    function ex(uint256 usdAmount) private returns (uint256, uint256) {\n', '        uint256 __stageUsdCap = stageUsdCap(_stage);\n', '        uint256 __tokenIssued;\n', '\n', '        // in stage\n', '        if (_stageUsdSold[_stage].add(usdAmount) <= __stageUsdCap) {\n', '            exCount(usdAmount);\n', '\n', '            __tokenIssued = usd2token(usdAmount);\n', '            assert(transfertokenIssued(__tokenIssued, usdAmount));\n', '\n', '            // close stage, if stage dollor cap reached\n', '            if (__stageUsdCap == _stageUsdSold[_stage]) {\n', '                assert(closeStage());\n', '            }\n', '\n', '            return (__tokenIssued, 0);\n', '        }\n', '\n', '        // close stage\n', '        uint256 __usdUsed = __stageUsdCap.sub(_stageUsdSold[_stage]);\n', '        uint256 __usdRemain = usdAmount.sub(__usdUsed);\n', '\n', '        exCount(__usdUsed);\n', '\n', '        __tokenIssued = usd2token(__usdUsed);\n', '        assert(transfertokenIssued(__tokenIssued, __usdUsed));\n', '        assert(closeStage());\n', '\n', '        return (__tokenIssued, __usdRemain);\n', '    }\n', '\n', '    function exCount(uint256 usdAmount) private {\n', '        uint256 __weiSold = usd2wei(usdAmount);\n', '        uint256 __weiTopSales = usd2weiTopSales(usdAmount);\n', '\n', '        _usdSeasonAccountPurchased[_season][msg.sender] = _usdSeasonAccountPurchased[_season][msg.sender].add(usdAmount);   // season => address => purchased, in USD\n', '\n', '        _stageUsdSold[_stage] = _stageUsdSold[_stage].add(usdAmount);                   // stage sold, in USD\n', '        _seasonWeiSold[_season] = _seasonWeiSold[_season].add(__weiSold);               // season sold, in wei\n', '        _seasonWeiTopSales[_season] = _seasonWeiTopSales[_season].add(__weiTopSales);   // season Top-Sales, in wei\n', '        _weiTopSales = _weiTopSales.add(__weiTopSales);                                 // sum Top-Sales, in wei\n', '\n', '        // season referral account\n', '        if (_inWhitelist_) {\n', '            for (uint16 i = 0; i < _rewards_.length; i++) {\n', '                _usdSeasonAccountRef[_season][_referrers_[i]] = _usdSeasonAccountRef[_season][_referrers_[i]].add(usdAmount);\n', '            }\n', '        }\n', '    }\n', '\n', '    function transfertokenIssued(uint256 amount, uint256 usdAmount) private returns (bool) {\n', '        _tokenTxs = _tokenTxs.add(1);\n', '\n', '        _tokenIssued = _tokenIssued.add(amount);\n', '        _stageTokenIssued[_stage] = _stageTokenIssued[_stage].add(amount);\n', '        _accountTokenIssued[msg.sender] = _accountTokenIssued[msg.sender].add(amount);\n', '\n', '        assert(TOKEN.transfer(msg.sender, amount));\n', '        emit TokenIssuedTransfered(_stage, msg.sender, amount, _etherPrice, usdAmount);\n', '        return true;\n', '    }\n', '\n', '    function transferTokenBonus(uint256 amount) private returns (bool) {\n', '        _tokenBonusTxs = _tokenBonusTxs.add(1);\n', '\n', '        _tokenBonus = _tokenBonus.add(amount);\n', '        _accountTokenBonus[msg.sender] = _accountTokenBonus[msg.sender].add(amount);\n', '\n', '        assert(TOKEN.transfer(msg.sender, amount));\n', '        emit TokenBonusTransfered(msg.sender, amount);\n', '        return true;\n', '    }\n', '\n', '    function transferTokenWhitelisted(uint256 amount) private returns (bool) {\n', '        _tokenWhitelistTxs = _tokenWhitelistTxs.add(1);\n', '\n', '        _tokenWhitelist = _tokenWhitelist.add(amount);\n', '        _accountTokenWhitelisted[msg.sender] = _accountTokenWhitelisted[msg.sender].add(amount);\n', '\n', '        assert(TOKEN.transfer(msg.sender, amount));\n', '        emit TokenWhitelistTransfered(msg.sender, amount);\n', '        return true;\n', '    }\n', '\n', '    function closeStage() private returns (bool) {\n', '        emit StageClosed(_stage, msg.sender);\n', '        _stage = _stage.add(1);\n', '        _tokenUsdPrice = stageTokenUsdPrice(_stage);\n', '        _topSalesRatio = topSalesRatio(_stage);\n', '\n', '        // Close current season\n', '        uint16 __seasonNumber = calcSeason(_stage);\n', '        if (_season < __seasonNumber) {\n', '            emit SeasonClosed(_season, msg.sender);\n', '            _season = __seasonNumber;\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    function sendWhitelistReferralRewards(uint256 weiAmount) private {\n', '        uint256 __weiRemain = weiAmount;\n', '        for (uint16 i = 0; i < _rewards_.length; i++) {\n', '            uint256 __weiReward = weiAmount.mul(_rewards_[i]).div(100);\n', '            address payable __receiver = address(uint160(_referrers_[i]));\n', '\n', '            _weiRefRewarded = _weiRefRewarded.add(__weiReward);\n', '            _accountWeiRefRewarded[__receiver] = _accountWeiRefRewarded[__receiver].add(__weiReward);\n', '            __weiRemain = __weiRemain.sub(__weiReward);\n', '\n', '            __receiver.transfer(__weiReward);\n', '        }\n', '\n', '        if (_pending_ > 0)\n', '            _weiPending = _weiPending.add(weiAmount.mul(_pending_).div(100));\n', '    }\n', '}']