['pragma solidity ^0.5.17;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function decimals() external view returns (uint);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != 0x0 && codehash != accountHash);\n', '    }\n', '    function toPayable(address account) internal pure returns (address payable) {\n', '        return address(uint160(account));\n', '    }\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-call-value\n', '        (bool success, ) = recipient.call.value(amount)("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '}\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', 'interface yVault {\n', '    function balance() external view returns (uint);\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address) external view returns (uint256);\n', '    function depositAll() external;\n', '    function withdraw(uint _shares) external;\n', '    function withdrawAll() external;\n', '}\n', '\n', 'interface Controller {\n', '    function vaults(address) external view returns (address);\n', '    function strategies(address) external view returns (address);\n', '    function rewards() external view returns (address);\n', '}\n', '\n', 'interface Strategy {\n', '    function withdrawalFee() external view returns (uint);\n', '}\n', '\n', '/* MakerDao interfaces */\n', '\n', 'interface GemLike {\n', '    function approve(address, uint) external;\n', '    function transfer(address, uint) external;\n', '    function transferFrom(address, address, uint) external;\n', '    function deposit() external payable;\n', '    function withdraw(uint) external;\n', '}\n', '\n', 'interface ManagerLike {\n', '    function cdpCan(address, uint, address) external view returns (uint);\n', '    function ilks(uint) external view returns (bytes32);\n', '    function owns(uint) external view returns (address);\n', '    function urns(uint) external view returns (address);\n', '    function vat() external view returns (address);\n', '    function open(bytes32, address) external returns (uint);\n', '    function give(uint, address) external;\n', '    function cdpAllow(uint, address, uint) external;\n', '    function urnAllow(address, uint) external;\n', '    function frob(uint, int, int) external;\n', '    function flux(uint, address, uint) external;\n', '    function move(uint, address, uint) external;\n', '    function exit(address, uint, address, uint) external;\n', '    function quit(uint, address) external;\n', '    function enter(address, uint) external;\n', '    function shift(uint, uint) external;\n', '}\n', '\n', 'interface VatLike {\n', '    function can(address, address) external view returns (uint);\n', '    function ilks(bytes32) external view returns (uint, uint, uint, uint, uint);\n', '    function dai(address) external view returns (uint);\n', '    function urns(bytes32, address) external view returns (uint, uint);\n', '    function frob(bytes32, address, address, address, int, int) external;\n', '    function hope(address) external;\n', '    function move(address, address, uint) external;\n', '}\n', '\n', 'interface GemJoinLike {\n', '    function dec() external returns (uint);\n', '    function gem() external returns (GemLike);\n', '    function join(address, uint) external payable;\n', '    function exit(address, uint) external;\n', '}\n', '\n', 'interface GNTJoinLike {\n', '    function bags(address) external view returns (address);\n', '    function make(address) external returns (address);\n', '}\n', '\n', 'interface DaiJoinLike {\n', '    function vat() external returns (VatLike);\n', '    function dai() external returns (GemLike);\n', '    function join(address, uint) external payable;\n', '    function exit(address, uint) external;\n', '}\n', '\n', 'interface HopeLike {\n', '    function hope(address) external;\n', '    function nope(address) external;\n', '}\n', '\n', 'interface EndLike {\n', '    function fix(bytes32) external view returns (uint);\n', '    function cash(bytes32, uint) external;\n', '    function free(bytes32) external;\n', '    function pack(uint) external;\n', '    function skim(bytes32, address) external;\n', '}\n', '\n', 'interface JugLike {\n', '    function drip(bytes32) external returns (uint);\n', '}\n', '\n', 'interface PotLike {\n', '    function pie(address) external view returns (uint);\n', '    function drip() external returns (uint);\n', '    function join(uint) external;\n', '    function exit(uint) external;\n', '}\n', '\n', 'interface SpotLike {\n', '    function ilks(bytes32) external view returns (address, uint);\n', '}\n', '\n', 'interface OSMedianizer {\n', '    function read() external view returns (uint, bool);\n', '    function foresight() external view returns (uint, bool);\n', '}\n', '\n', 'interface Uni {\n', '    function swapExactTokensForTokens(uint, uint, address[] calldata, address, uint) external;\n', '}\n', '\n', '/*\n', '\n', ' A strategy must implement the following calls;\n', '\n', ' - deposit()\n', ' - withdraw(address) must exclude any tokens used in the yield - Controller role - withdraw should return to Controller\n', ' - withdraw(uint) - Controller | Vault role - withdraw should always return to vault\n', ' - withdrawAll() - Controller | Vault role - withdraw should always return to vault\n', ' - balanceOf()\n', '\n', ' Where possible, strategies must remain as immutable as possible, instead of updating variables, we update the contract by linking it in the controller\n', '\n', '*/\n', '\n', 'contract StrategyMKRVaultDAIDelegate {\n', '    using SafeERC20 for IERC20;\n', '    using Address for address;\n', '    using SafeMath for uint256;\n', '\n', '    address constant public token = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);\n', '    address constant public want = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);\n', '    address constant public weth = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);\n', '    address constant public dai = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);\n', '\n', '    address public cdp_manager = address(0x5ef30b9986345249bc32d8928B7ee64DE9435E39);\n', '    address public vat = address(0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B);\n', '    address public mcd_join_eth_a = address(0x2F0b23f53734252Bda2277357e97e1517d6B042A);\n', '    address public mcd_join_dai = address(0x9759A6Ac90977b93B58547b4A71c78317f391A28);\n', '    address public mcd_spot = address(0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3);\n', '    address public jug = address(0x19c0976f590D67707E62397C87829d896Dc0f1F1);\n', '\n', '    address constant public eth_price_oracle = address(0xCF63089A8aD2a9D8BD6Bb8022f3190EB7e1eD0f1);\n', '    address constant public yVaultDAI = address(0xACd43E627e64355f1861cEC6d3a6688B31a6F952);\n', '\n', '    address constant public unirouter = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n', '\n', '    uint public c = 20000;\n', '    uint public c_safe = 40000;\n', '    uint constant public c_base = 10000;\n', '\n', '    uint public performanceFee = 500;\n', '    uint constant public performanceMax = 10000;\n', '\n', '    uint public withdrawalFee = 50;\n', '    uint constant public withdrawalMax = 10000;\n', '\n', '    bytes32 constant public ilk = "ETH-A";\n', '\n', '    address public governance;\n', '    address public controller;\n', '    address public strategist;\n', '    address public harvester;\n', '\n', '    uint public cdpId;\n', '\n', '    constructor(address _controller) public {\n', '        governance = msg.sender;\n', '        strategist = 0x2839df1F230dedA9fDDBF1BCB0D4eB1Ee1f7b7d0;\n', '        harvester = msg.sender;\n', '        controller = _controller;\n', '        cdpId = ManagerLike(cdp_manager).open(ilk, address(this));\n', '        _approveAll();\n', '    }\n', '\n', '    function getName() external pure returns (string memory) {\n', '        return "StrategyMKRVaultDAIDelegate";\n', '    }\n', '\n', '    function setStrategist(address _strategist) external {\n', '        require(msg.sender == governance, "!governance");\n', '        strategist = _strategist;\n', '    }\n', '\n', '    function setHarvester(address _harvester) external {\n', '        require(msg.sender == harvester || msg.sender == governance, "!allowed");\n', '        harvester = _harvester;\n', '    }\n', '\n', '    function setWithdrawalFee(uint _withdrawalFee) external {\n', '        require(msg.sender == governance, "!governance");\n', '        withdrawalFee = _withdrawalFee;\n', '    }\n', '\n', '    function setPerformanceFee(uint _performanceFee) external {\n', '        require(msg.sender == governance, "!governance");\n', '        performanceFee = _performanceFee;\n', '    }\n', '\n', '    function setBorrowCollateralizationRatio(uint _c) external {\n', '        require(msg.sender == governance, "!governance");\n', '        c = _c;\n', '    }\n', '\n', '    function setWithdrawCollateralizationRatio(uint _c_safe) external {\n', '        require(msg.sender == governance, "!governance");\n', '        c_safe = _c_safe;\n', '    }\n', '\n', '    // optional\n', '    function setMCDValue(\n', '        address _manager,\n', '        address _ethAdapter,\n', '        address _daiAdapter,\n', '        address _spot,\n', '        address _jug\n', '    ) external {\n', '        require(msg.sender == governance, "!governance");\n', '        cdp_manager = _manager;\n', '        vat = ManagerLike(_manager).vat();\n', '        mcd_join_eth_a = _ethAdapter;\n', '        mcd_join_dai = _daiAdapter;\n', '        mcd_spot = _spot;\n', '        jug = _jug;\n', '    }\n', '\n', '    function _approveAll() internal {\n', '        IERC20(token).approve(mcd_join_eth_a, uint(-1));\n', '        IERC20(dai).approve(mcd_join_dai, uint(-1));\n', '        IERC20(dai).approve(yVaultDAI, uint(-1));\n', '        IERC20(dai).approve(unirouter, uint(-1));\n', '    }\n', '\n', '    function deposit() public {\n', '        uint _token = IERC20(token).balanceOf(address(this));\n', '        if (_token > 0) {\n', '            uint p = _getPrice();\n', '            uint _draw = _token.mul(p).mul(c_base).div(c).div(1e18);\n', '            //// approve adapter to use token amount\n', '            require(_checkDebtCeiling(_draw), "debt ceiling is reached!");\n', '            _lockWETHAndDrawDAI(_token, _draw);\n', '\n', '            //// approve yVaultDAI use DAI\n', '            yVault(yVaultDAI).depositAll();\n', '        }\n', '    }\n', '\n', '    function _getPrice() internal view returns (uint p) {\n', '        (uint _read,) = OSMedianizer(eth_price_oracle).read();\n', '        (uint _foresight,) = OSMedianizer(eth_price_oracle).foresight();\n', '        p = _foresight < _read ? _foresight : _read;\n', '    }\n', '\n', '    function _checkDebtCeiling(uint _amt) internal view returns (bool) {\n', '        (,,,uint _line,) = VatLike(vat).ilks(ilk);\n', '        uint _debt = getTotalDebtAmount().add(_amt);\n', '        if (_line.div(1e27) < _debt) { return false; }\n', '        return true;\n', '    }\n', '\n', '    function _lockWETHAndDrawDAI(uint wad, uint wadD) internal {\n', '        address urn = ManagerLike(cdp_manager).urns(cdpId);\n', '\n', '        //// GemJoinLike(mcd_join_eth_a).gem().approve(mcd_join_eth_a, wad);\n', '        GemJoinLike(mcd_join_eth_a).join(urn, wad);\n', '        ManagerLike(cdp_manager).frob(cdpId, toInt(wad), _getDrawDart(urn, wadD));\n', '        ManagerLike(cdp_manager).move(cdpId, address(this), wadD.mul(1e27));\n', '        if (VatLike(vat).can(address(this), address(mcd_join_dai)) == 0) {\n', '            VatLike(vat).hope(mcd_join_dai);\n', '        }\n', '        DaiJoinLike(mcd_join_dai).exit(address(this), wadD);\n', '    }\n', '\n', '    function _getDrawDart(address urn, uint wad) internal returns (int dart) {\n', '        uint rate = JugLike(jug).drip(ilk);\n', '        uint _dai = VatLike(vat).dai(urn);\n', '\n', '        // If there was already enough DAI in the vat balance, just exits it without adding more debt\n', '        if (_dai < wad.mul(1e27)) {\n', '            dart = toInt(wad.mul(1e27).sub(_dai).div(rate));\n', '            dart = uint(dart).mul(rate) < wad.mul(1e27) ? dart + 1 : dart;\n', '        }\n', '    }\n', '\n', '    function toInt(uint x) internal pure returns (int y) {\n', '        y = int(x);\n', '        require(y >= 0, "int-overflow");\n', '    }\n', '\n', '    // Controller only function for creating additional rewards from dust\n', '    function withdraw(IERC20 _asset) external returns (uint balance) {\n', '        require(msg.sender == controller, "!controller");\n', '        require(want != address(_asset), "want");\n', '        require(dai != address(_asset), "dai");\n', '        balance = _asset.balanceOf(address(this));\n', '        _asset.safeTransfer(controller, balance);\n', '    }\n', '\n', '    // Withdraw partial funds, normally used with a vault withdrawal\n', '    function withdraw(uint _amount) external {\n', '        require(msg.sender == controller, "!controller");\n', '        uint _balance = IERC20(want).balanceOf(address(this));\n', '        if (_balance < _amount) {\n', '            _amount = _withdrawSome(_amount.sub(_balance));\n', '            _amount = _amount.add(_balance);\n', '        }\n', '\n', '        uint _fee = _amount.mul(withdrawalFee).div(withdrawalMax);\n', '\n', '        IERC20(want).safeTransfer(Controller(controller).rewards(), _fee);\n', '        address _vault = Controller(controller).vaults(address(want));\n', '        require(_vault != address(0), "!vault"); // additional protection so we don\'t burn the funds\n', '\n', '        IERC20(want).safeTransfer(_vault, _amount.sub(_fee));\n', '    }\n', '    \n', '    function shouldRebalance() external view returns (bool) {\n', '        return getmVaultRatio() < c_safe.mul(1e2);\n', '    }\n', '    \n', '    function rebalance() external {\n', '        uint safe = c_safe.mul(1e2);\n', '        if (getmVaultRatio() < safe) {\n', '            uint d = getTotalDebtAmount();\n', '            uint diff = safe.sub(getmVaultRatio());\n', '            uint free = d.mul(diff).div(safe);\n', '            uint p = _getPrice();\n', '            _wipe(_withdrawDai(free.mul(p).div(1e18)));\n', '        }\n', '    }\n', '    \n', '    function forceRebalance(uint _amount) external {\n', '        require(msg.sender == governance, "!governance");\n', '        uint p = _getPrice();\n', '        _wipe(_withdrawDai(_amount.mul(p).div(1e18)));\n', '    }\n', '\n', '    function _withdrawSome(uint256 _amount) internal returns (uint) {\n', '        uint p = _getPrice();\n', '        \n', '        if (getmVaultRatioNext(_amount) < c_safe.mul(1e2)) {\n', '            _wipe(_withdrawDai(_amount.mul(p).div(1e18)));\n', '        }\n', '        \n', '        // _amount in want\n', '        _freeWETH(_amount);\n', '\n', '        if (getmVaultRatio() < c_safe.mul(1e2)) {\n', '            _wipe(_withdrawDai(_amount.mul(p).div(1e18)));\n', '        }\n', '        \n', '        return _amount;\n', '    }\n', '\n', '    function _freeWETH(uint wad) internal {\n', '        ManagerLike(cdp_manager).frob(cdpId, -toInt(wad), 0);\n', '        ManagerLike(cdp_manager).flux(cdpId, address(this), wad);\n', '        GemJoinLike(mcd_join_eth_a).exit(address(this), wad);\n', '    }\n', '\n', '    function _wipe(uint wad) internal {\n', '        // wad in DAI\n', '        address urn = ManagerLike(cdp_manager).urns(cdpId);\n', '\n', '        DaiJoinLike(mcd_join_dai).join(urn, wad);\n', '        ManagerLike(cdp_manager).frob(cdpId, 0, _getWipeDart(VatLike(vat).dai(urn), urn));\n', '    }\n', '\n', '    function _getWipeDart(\n', '        uint _dai,\n', '        address urn\n', '    ) internal view returns (int dart) {\n', '        (, uint rate,,,) = VatLike(vat).ilks(ilk);\n', '        (, uint art) = VatLike(vat).urns(ilk, urn);\n', '\n', '        dart = toInt(_dai / rate);\n', '        dart = uint(dart) <= art ? - dart : - toInt(art);\n', '    }\n', '\n', '    // Withdraw all funds, normally used when migrating strategies\n', '    function withdrawAll() external returns (uint balance) {\n', '        require(msg.sender == controller, "!controller");\n', '        _withdrawAll();\n', '\n', '        _swap(IERC20(dai).balanceOf(address(this)));\n', '        balance = IERC20(want).balanceOf(address(this));\n', '\n', '        address _vault = Controller(controller).vaults(address(want));\n', '        require(_vault != address(0), "!vault"); // additional protection so we don\'t burn the funds\n', '        IERC20(want).safeTransfer(_vault, balance);\n', '    }\n', '\n', '    function _withdrawAll() internal {\n', '        yVault(yVaultDAI).withdrawAll(); // get Dai\n', '        _wipe(getTotalDebtAmount().add(1)); // in case of edge case\n', '        _freeWETH(balanceOfmVault());\n', '    }\n', '\n', '    function balanceOf() public view returns (uint) {\n', '        return balanceOfWant()\n', '               .add(balanceOfmVault());\n', '    }\n', '\n', '    function balanceOfWant() public view returns (uint) {\n', '        return IERC20(want).balanceOf(address(this));\n', '    }\n', '\n', '    function balanceOfmVault() public view returns (uint) {\n', '        uint ink;\n', '        address urnHandler = ManagerLike(cdp_manager).urns(cdpId);\n', '        (ink,) = VatLike(vat).urns(ilk, urnHandler);\n', '        return ink;\n', '    }\n', '\n', '    function harvest() public {\n', '        require(msg.sender == strategist || msg.sender == harvester || msg.sender == governance, "!authorized");\n', '        \n', '        uint v = getUnderlyingDai(yVault(yVaultDAI).balanceOf(address(this)));\n', '        uint d = getTotalDebtAmount();\n', '        require(v > d, "profit is not realized yet!");\n', '        uint profit = v.sub(d);\n', '\n', '        _swap(_withdrawDai(profit));\n', '\n', '        uint _want = IERC20(want).balanceOf(address(this));\n', '        if (_want > 0) {\n', '            uint _fee = _want.mul(performanceFee).div(performanceMax);\n', '            IERC20(want).safeTransfer(strategist, _fee);\n', '            _want = _want.sub(_fee);\n', '        }\n', '\n', '        deposit();\n', '    }\n', '\n', '    function payback(uint _amount) public {\n', '        // _amount in Dai\n', '        _wipe(_withdrawDai(_amount));\n', '    }\n', '\n', '    function getTotalDebtAmount() public view returns (uint) {\n', '        uint art;\n', '        uint rate;\n', '        address urnHandler = ManagerLike(cdp_manager).urns(cdpId);\n', '        (,art) = VatLike(vat).urns(ilk, urnHandler);\n', '        (,rate,,,) = VatLike(vat).ilks(ilk);\n', '        return art.mul(rate).div(1e27);\n', '    }\n', '    \n', '    function getmVaultRatioNext(uint amount) public view returns (uint) {\n', '        uint spot; // ray\n', '        uint liquidationRatio; // ray\n', '        uint denominator = getTotalDebtAmount();\n', '        (,,spot,,) = VatLike(vat).ilks(ilk);\n', '        (,liquidationRatio) = SpotLike(mcd_spot).ilks(ilk);\n', '        uint delayedCPrice = spot.mul(liquidationRatio).div(1e27); // ray\n', '        uint numerator = (balanceOfmVault().sub(amount)).mul(delayedCPrice).div(1e18); // ray\n', '        return numerator.div(denominator).div(1e3);\n', '    }\n', '\n', '    function getmVaultRatio() public view returns (uint) {\n', '        uint spot; // ray\n', '        uint liquidationRatio; // ray\n', '        uint denominator = getTotalDebtAmount();\n', '        (,,spot,,) = VatLike(vat).ilks(ilk);\n', '        (,liquidationRatio) = SpotLike(mcd_spot).ilks(ilk);\n', '        uint delayedCPrice = spot.mul(liquidationRatio).div(1e27); // ray\n', '        uint numerator = balanceOfmVault().mul(delayedCPrice).div(1e18); // ray\n', '        return numerator.div(denominator).div(1e3);\n', '    }\n', '\n', '    function getUnderlyingWithdrawalFee() public view returns (uint) {\n', '        address _strategy = Controller(controller).strategies(dai);\n', '        return Strategy(_strategy).withdrawalFee();\n', '    }\n', '\n', '    function getUnderlyingDai(uint _shares) public view returns (uint) {\n', '        return (yVault(yVaultDAI).balance())\n', '                .mul(_shares).div(yVault(yVaultDAI).totalSupply())\n', '                .mul(withdrawalMax.sub(getUnderlyingWithdrawalFee()))\n', '                .div(withdrawalMax);\n', '    }\n', '\n', '    function _withdrawDai(uint _amount) internal returns (uint) {\n', '        uint _shares = _amount\n', '                        .mul(yVault(yVaultDAI).totalSupply())\n', '                        .div(yVault(yVaultDAI).balance())\n', '                        .mul(withdrawalMax)\n', '                        .div(withdrawalMax.sub(getUnderlyingWithdrawalFee()));\n', '        yVault(yVaultDAI).withdraw(_shares);\n', '        return IERC20(dai).balanceOf(address(this));\n', '    }\n', '\n', '    function _swap(uint _amountIn) internal {\n', '        address[] memory path = new address[](2);\n', '        path[0] = address(dai);\n', '        path[1] = address(want);\n', '\n', '        //// approve unirouter to use dai\n', '        Uni(unirouter).swapExactTokensForTokens(_amountIn, 0, path, address(this), now.add(1 days));\n', '    }\n', '\n', '    function setGovernance(address _governance) external {\n', '        require(msg.sender == governance, "!governance");\n', '        governance = _governance;\n', '    }\n', '\n', '    function setController(address _controller) external {\n', '        require(msg.sender == governance, "!governance");\n', '        controller = _controller;\n', '    }\n', '}']