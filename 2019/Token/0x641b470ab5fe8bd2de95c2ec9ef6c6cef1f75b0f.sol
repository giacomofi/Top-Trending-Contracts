['pragma solidity 0.5.0;\n', '\n', '// File: openzeppelin-solidity/contracts/access/Roles.sol\n', '\n', '/**\n', ' * @title Roles\n', ' * @dev Library for managing addresses assigned to a Role.\n', ' */\n', 'library Roles {\n', '    struct Role {\n', '        mapping (address => bool) bearer;\n', '    }\n', '\n', '    /**\n', '     * @dev give an account access to this role\n', '     */\n', '    function add(Role storage role, address account) internal {\n', '        require(account != address(0));\n', '        require(!has(role, account));\n', '\n', '        role.bearer[account] = true;\n', '    }\n', '\n', '    /**\n', "     * @dev remove an account's access to this role\n", '     */\n', '    function remove(Role storage role, address account) internal {\n', '        require(account != address(0));\n', '        require(has(role, account));\n', '\n', '        role.bearer[account] = false;\n', '    }\n', '\n', '    /**\n', '     * @dev check if an account has this role\n', '     * @return bool\n', '     */\n', '    function has(Role storage role, address account) internal view returns (bool) {\n', '        require(account != address(0));\n', '        return role.bearer[account];\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol\n', '\n', 'contract PauserRole {\n', '    using Roles for Roles.Role;\n', '\n', '    event PauserAdded(address indexed account);\n', '    event PauserRemoved(address indexed account);\n', '\n', '    Roles.Role private _pausers;\n', '\n', '    constructor () internal {\n', '        _addPauser(msg.sender);\n', '    }\n', '\n', '    modifier onlyPauser() {\n', '        require(isPauser(msg.sender));\n', '        _;\n', '    }\n', '\n', '    function isPauser(address account) public view returns (bool) {\n', '        return _pausers.has(account);\n', '    }\n', '\n', '    function addPauser(address account) public onlyPauser {\n', '        _addPauser(account);\n', '    }\n', '\n', '    function renouncePauser() public {\n', '        _removePauser(msg.sender);\n', '    }\n', '\n', '    function _addPauser(address account) internal {\n', '        _pausers.add(account);\n', '        emit PauserAdded(account);\n', '    }\n', '\n', '    function _removePauser(address account) internal {\n', '        _pausers.remove(account);\n', '        emit PauserRemoved(account);\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is PauserRole {\n', '    event Paused(address account);\n', '    event Unpaused(address account);\n', '\n', '    bool private _paused;\n', '\n', '    constructor () internal {\n', '        _paused = false;\n', '    }\n', '\n', '    /**\n', '     * @return true if the contract is paused, false otherwise.\n', '     */\n', '    function paused() public view returns (bool) {\n', '        return _paused;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!_paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(_paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() public onlyPauser whenNotPaused {\n', '        _paused = true;\n', '        emit Paused(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() public onlyPauser whenPaused {\n', '        _paused = false;\n', '        emit Unpaused(msg.sender);\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: lib/ds-math/src/math.sol\n', '\n', '/// math.sol -- mixin for inline numerical wizardry\n', '\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU General Public License for more details.\n', '\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', '\n', 'pragma solidity >0.4.13;\n', '\n', 'contract DSMath {\n', '    function add(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x + y) >= x, "ds-math-add-overflow");\n', '    }\n', '    function sub(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x - y) <= x, "ds-math-sub-underflow");\n', '    }\n', '    function mul(uint x, uint y) internal pure returns (uint z) {\n', '        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");\n', '    }\n', '\n', '    function min(uint x, uint y) internal pure returns (uint z) {\n', '        return x <= y ? x : y;\n', '    }\n', '    function max(uint x, uint y) internal pure returns (uint z) {\n', '        return x >= y ? x : y;\n', '    }\n', '    function imin(int x, int y) internal pure returns (int z) {\n', '        return x <= y ? x : y;\n', '    }\n', '    function imax(int x, int y) internal pure returns (int z) {\n', '        return x >= y ? x : y;\n', '    }\n', '\n', '    uint constant WAD = 10 ** 18;\n', '    uint constant RAY = 10 ** 27;\n', '\n', '    function wmul(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, y), WAD / 2) / WAD;\n', '    }\n', '    function rmul(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, y), RAY / 2) / RAY;\n', '    }\n', '    function wdiv(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, WAD), y / 2) / y;\n', '    }\n', '    function rdiv(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, RAY), y / 2) / y;\n', '    }\n', '\n', '    // This famous algorithm is called "exponentiation by squaring"\n', '    // and calculates x^n with x as fixed-point and n as regular unsigned.\n', '    //\n', "    // It's O(log n), instead of O(n) for naive repeated multiplication.\n", '    //\n', '    // These facts are why it works:\n', '    //\n', '    //  If n is even, then x^n = (x^2)^(n/2).\n', '    //  If n is odd,  then x^n = x * x^(n-1),\n', '    //   and applying the equation for even x gives\n', '    //    x^n = x * (x^2)^((n-1) / 2).\n', '    //\n', '    //  Also, EVM division is flooring and\n', '    //    floor[(n-1) / 2] = floor[n / 2].\n', '    //\n', '    function rpow(uint x, uint n) internal pure returns (uint z) {\n', '        z = n % 2 != 0 ? x : RAY;\n', '\n', '        for (n /= 2; n != 0; n /= 2) {\n', '            x = rmul(x, x);\n', '\n', '            if (n % 2 != 0) {\n', '                z = rmul(z, x);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/interfaces/IWrappedEther.sol\n', '\n', 'contract IWrappedEther is IERC20 {\n', '    function deposit() external payable;\n', '    function withdraw(uint amount) external;\n', '}\n', '\n', '// File: contracts/interfaces/ISaiTub.sol\n', '\n', 'interface DSValue {\n', '    function peek() external view returns (bytes32, bool);\n', '}\n', '\n', 'interface ISaiTub {\n', '    function sai() external view returns (IERC20);  // Stablecoin\n', '    function sin() external view returns (IERC20);  // Debt (negative sai)\n', '    function skr() external view returns (IERC20);  // Abstracted collateral\n', '    function gem() external view returns (IWrappedEther);  // Underlying collateral\n', '    function gov() external view returns (IERC20);  // Governance token\n', '\n', '    function open() external returns (bytes32 cup);\n', '    function join(uint wad) external;\n', '    function exit(uint wad) external;\n', '    function give(bytes32 cup, address guy) external;\n', '    function lock(bytes32 cup, uint wad) external;\n', '    function free(bytes32 cup, uint wad) external;\n', '    function draw(bytes32 cup, uint wad) external;\n', '    function wipe(bytes32 cup, uint wad) external;\n', '    function shut(bytes32 cup) external;\n', '    function per() external view returns (uint ray);\n', '    function lad(bytes32 cup) external view returns (address);\n', '    \n', '    function tab(bytes32 cup) external returns (uint);\n', '    function rap(bytes32 cup) external returns (uint);\n', '    function ink(bytes32 cup) external view returns (uint);\n', '    function mat() external view returns (uint);    // Liquidation ratio\n', '    function fee() external view returns (uint);    // Governance fee\n', '    function pep() external view returns (DSValue); // Governance price feed\n', '    function cap() external view returns (uint); // Debt ceiling\n', '    \n', '\n', '    function cups(bytes32) external view returns (address, uint, uint, uint);\n', '}\n', '\n', '// File: contracts/interfaces/IDex.sol\n', '\n', 'interface IDex {\n', '    function getPayAmount(IERC20 pay_gem, IERC20 buy_gem, uint buy_amt) external view returns (uint);\n', '    function buyAllAmount(IERC20 buy_gem, uint buy_amt, IERC20 pay_gem, uint max_fill_amount) external returns (uint);\n', '    function offer(\n', '        uint pay_amt,    //maker (ask) sell how much\n', '        IERC20 pay_gem,   //maker (ask) sell which token\n', '        uint buy_amt,    //maker (ask) buy how much\n', '        IERC20 buy_gem,   //maker (ask) buy which token\n', '        uint pos         //position to insert offer, 0 should be used if unknown\n', '    )\n', '    external\n', '    returns (uint);\n', '}\n', '\n', '// File: contracts/ArrayUtils.sol\n', '\n', 'library ArrayUtils {\n', '    function removeElement(bytes32[] storage array, uint index) internal {\n', '        if (index >= array.length) return;\n', '\n', '        for (uint i = index; i < array.length - 1; i++) {\n', '            array[i] = array[i + 1];\n', '        }\n', '        delete array[array.length - 1];\n', '        array.length--;\n', '    }\n', '\n', '    function findElement(bytes32[] storage array, bytes32 element) internal view returns (uint index, bool ok) {\n', '        for (uint i = 0; i < array.length; i++) {\n', '            if (array[i] == element) {\n', '                return (i, true);\n', '            }\n', '        }\n', '\n', '        return (0, false);\n', '    }\n', '}\n', '\n', '// File: contracts/MakerDaoGateway.sol\n', '\n', 'contract MakerDaoGateway is Pausable, DSMath {\n', '    using ArrayUtils for bytes32[];\n', '\n', '    ISaiTub public saiTub;\n', '    IDex public dex;\n', '    IWrappedEther public weth;\n', '    IERC20 public peth;\n', '    IERC20 public dai;\n', '    IERC20 public mkr;\n', '\n', '    mapping(bytes32 => address) public cdpOwner;\n', '    mapping(address => bytes32[]) public cdpsByOwner;\n', '\n', '    event CdpOpened(address indexed owner, bytes32 cdpId);\n', '    event CdpClosed(address indexed owner, bytes32 cdpId);\n', '    event CollateralSupplied(address indexed owner, bytes32 cdpId, uint wethAmount, uint pethAmount);\n', '    event DaiBorrowed(address indexed owner, bytes32 cdpId, uint amount);\n', '    event DaiRepaid(address indexed owner, bytes32 cdpId, uint amount);\n', '    event CollateralReturned(address indexed owner, bytes32 cdpId, uint wethAmount, uint pethAmount);\n', '    event CdpTransferred(address indexed oldOwner, address indexed newOwner, bytes32 cdpId);\n', '    event CdpEjected(address indexed newOwner, bytes32 cdpId);\n', '    event CdpRegistered(address indexed newOwner, bytes32 cdpId);\n', '\n', '    modifier isCdpOwner(bytes32 cdpId) {\n', '        require(cdpOwner[cdpId] == msg.sender || cdpId == 0, "CDP belongs to a different address");\n', '        _;\n', '    }\n', '\n', '    constructor(ISaiTub _saiTub, IDex _dex) public {\n', '        saiTub = _saiTub;\n', '        dex = _dex;\n', '        weth = saiTub.gem();\n', '        peth = saiTub.skr();\n', '        dai = saiTub.sai();\n', '        mkr = saiTub.gov();\n', '    }\n', '\n', '    function cdpsByOwnerLength(address _owner) external view returns (uint) {\n', '        return cdpsByOwner[_owner].length;\n', '    }\n', '\n', '    function systemParameters() external view returns (uint liquidationRatio, uint annualStabilityFee, uint daiAvailable) {\n', '        liquidationRatio = saiTub.mat();\n', '        annualStabilityFee = rpow(saiTub.fee(), 365 days);\n', '        daiAvailable = sub(saiTub.cap(), dai.totalSupply());\n', '    }\n', '    \n', '    function cdpInfo(bytes32 cdpId) external returns (uint borrowedDai, uint outstandingDai, uint suppliedPeth) {\n', '        (, uint ink, uint art, ) = saiTub.cups(cdpId);\n', '        borrowedDai = art;\n', '        suppliedPeth = ink;\n', '        outstandingDai = add(saiTub.rap(cdpId), saiTub.tab(cdpId));\n', '    }\n', '    \n', '    function pethForWeth(uint wethAmount) public view returns (uint) {\n', '        return rdiv(wethAmount, saiTub.per());\n', '    }\n', '\n', '    function wethForPeth(uint pethAmount) public view returns (uint) {\n', '        return rmul(pethAmount, saiTub.per());\n', '    }\n', '\n', '    function() external payable {\n', '        // For unwrapping WETH\n', '    }\n', '\n', '    // SUPPLY AND BORROW\n', '    \n', '    // specify cdpId if you want to use existing CDP, or pass 0 if you need to create a new one\n', '    // for new and active CDPs collateral amount should be > 0.005 PETH\n', '    function supplyEthAndBorrowDai(bytes32 cdpId, uint daiAmount) whenNotPaused isCdpOwner(cdpId) external payable {\n', '        bytes32 id = supplyEth(cdpId);\n', '        borrowDai(id, daiAmount);\n', '    }\n', '\n', '    // specify cdpId if you want to use existing CDP, or pass 0 if you need to create a new one \n', '    function supplyWethAndBorrowDai(bytes32 cdpId, uint wethAmount, uint daiAmount) whenNotPaused isCdpOwner(cdpId) external {\n', '        bytes32 id = supplyWeth(cdpId, wethAmount);\n', '        borrowDai(id, daiAmount);\n', '    }\n', '\n', '    // returns id of actual CDP (existing or a new one)\n', '    // for new and active CDPs collateral amount should be > 0.005 PETH\n', '    function supplyEth(bytes32 cdpId) whenNotPaused isCdpOwner(cdpId) public payable returns (bytes32 _cdpId) {\n', '        if (msg.value > 0) {\n', '            weth.deposit.value(msg.value)();\n', '            return _supply(cdpId, msg.value);\n', '        }\n', '\n', '        return cdpId;\n', '    }\n', '\n', '    // for new and active CDPs collateral amount should be > 0.005 PETH\n', "    // don't forget to approve WETH before supplying\n", '    // returns id of actual CDP (existing or a new one)\n', '    function supplyWeth(bytes32 cdpId, uint wethAmount) whenNotPaused isCdpOwner(cdpId) public returns (bytes32 _cdpId) {\n', '        if (wethAmount > 0) {\n', '            require(weth.transferFrom(msg.sender, address(this), wethAmount));\n', '            return _supply(cdpId, wethAmount);\n', '        }\n', '\n', '        return cdpId;\n', '    }\n', '\n', '    function borrowDai(bytes32 cdpId, uint daiAmount) whenNotPaused isCdpOwner(cdpId) public {\n', '        if (daiAmount > 0) {\n', '            saiTub.draw(cdpId, daiAmount);\n', '\n', '            require(dai.transfer(msg.sender, daiAmount));\n', '\n', '            emit DaiBorrowed(msg.sender, cdpId, daiAmount);\n', '        }\n', '    }\n', '\n', '    // REPAY AND RETURN\n', '\n', "    // don't forget to approve DAI before repaying\n", '    function repayDaiAndReturnEth(bytes32 cdpId, uint daiAmount, uint ethAmount, bool payFeeInDai) whenNotPaused isCdpOwner(cdpId) external {\n', '        repayDai(cdpId, daiAmount, payFeeInDai);\n', '        returnEth(cdpId, ethAmount);\n', '    }\n', '\n', "    // don't forget to approve DAI before repaying\n", '    // pass -1 to daiAmount to repay all outstanding debt\n', '    // pass -1 to wethAmount to return all collateral\n', '    function repayDaiAndReturnWeth(bytes32 cdpId, uint daiAmount, uint wethAmount, bool payFeeInDai) whenNotPaused isCdpOwner(cdpId) public {\n', '        repayDai(cdpId, daiAmount, payFeeInDai);\n', '        returnWeth(cdpId, wethAmount);\n', '    }\n', '\n', "    // don't forget to approve DAI before repaying\n", '    // pass -1 to daiAmount to repay all outstanding debt\n', '    function repayDai(bytes32 cdpId, uint daiAmount, bool payFeeInDai) whenNotPaused isCdpOwner(cdpId) public {\n', '        if (daiAmount > 0) {\n', '            uint _daiAmount = daiAmount;\n', '            if (_daiAmount == uint(- 1)) {\n', '                // repay all outstanding debt\n', '                _daiAmount = saiTub.tab(cdpId);\n', '            }\n', '\n', '            _ensureApproval(dai, address(saiTub));\n', '            _ensureApproval(mkr, address(saiTub));\n', '\n', '            uint govFeeAmount = _calcGovernanceFee(cdpId, _daiAmount);\n', '            _handleGovFee(govFeeAmount, payFeeInDai);\n', '\n', '            require(dai.transferFrom(msg.sender, address(this), _daiAmount));\n', '\n', '            saiTub.wipe(cdpId, _daiAmount);\n', '\n', '            emit DaiRepaid(msg.sender, cdpId, _daiAmount);\n', '        }\n', '    }\n', '\n', '    function returnEth(bytes32 cdpId, uint ethAmount) whenNotPaused isCdpOwner(cdpId) public {\n', '        if (ethAmount > 0) {\n', '            uint effectiveWethAmount = _return(cdpId, ethAmount);\n', '            weth.withdraw(effectiveWethAmount);\n', '            msg.sender.transfer(effectiveWethAmount);\n', '        }\n', '    }\n', '\n', '    function returnWeth(bytes32 cdpId, uint wethAmount) whenNotPaused isCdpOwner(cdpId) public {\n', '        if (wethAmount > 0) {\n', '            uint effectiveWethAmount = _return(cdpId, wethAmount);\n', '            require(weth.transfer(msg.sender, effectiveWethAmount));\n', '        }\n', '    }\n', '\n', '    function closeCdp(bytes32 cdpId, bool payFeeInDai) whenNotPaused isCdpOwner(cdpId) external {\n', '        repayDaiAndReturnWeth(cdpId, uint(-1), uint(-1), payFeeInDai);\n', '        _removeCdp(cdpId, msg.sender);\n', '        saiTub.shut(cdpId);\n', '        \n', '        emit CdpClosed(msg.sender, cdpId);\n', '    }\n', '\n', '    // TRANSFER AND ADOPT\n', '\n', '    // You can migrate your CDP from MakerDaoGateway contract to another owner\n', '    function transferCdp(bytes32 cdpId, address nextOwner) isCdpOwner(cdpId) external {\n', '        address _owner = nextOwner;\n', '        if (_owner == address(0x0)) {\n', '            _owner = msg.sender;\n', '        }\n', '        \n', '        saiTub.give(cdpId, _owner);\n', '\n', '        _removeCdp(cdpId, msg.sender);\n', '\n', '        emit CdpTransferred(msg.sender, _owner, cdpId);\n', '    }\n', '    \n', '    function ejectCdp(bytes32 cdpId) onlyPauser external {\n', '        address owner = cdpOwner[cdpId];\n', '        saiTub.give(cdpId, owner);\n', '\n', '        _removeCdp(cdpId, owner);\n', '\n', '        emit CdpEjected(owner, cdpId);\n', '    }\n', '\n', '    // If you want to migrate existing CDP to MakerDaoGateway contract,\n', '    // you need to register your cdp first with this function, and then execute `give` operation,\n', '    // transferring CDP to the MakerDaoGateway contract\n', '    function registerCdp(bytes32 cdpId, address owner) whenNotPaused external {\n', '        require(saiTub.lad(cdpId) == msg.sender, "Can\'t register other\'s CDP");\n', '        require(cdpOwner[cdpId] == address(0x0), "Can\'t register CDP twice");\n', '\n', '        address _owner = owner;\n', '        if (_owner == address(0x0)) {\n', '            _owner = msg.sender;\n', '        }\n', '\n', '        cdpOwner[cdpId] = _owner;\n', '        cdpsByOwner[_owner].push(cdpId);\n', '\n', '        emit CdpRegistered(_owner, cdpId);\n', '    }\n', '\n', '    // INTERNAL FUNCTIONS\n', '\n', '    function _supply(bytes32 cdpId, uint wethAmount) internal returns (bytes32 _cdpId) {\n', '        _cdpId = cdpId;\n', '        if (_cdpId == 0) {\n', '            _cdpId = _createCdp();\n', '        }\n', '\n', '        _ensureApproval(weth, address(saiTub));\n', '\n', '        uint pethAmount = pethForWeth(wethAmount);\n', '\n', '        saiTub.join(pethAmount);\n', '\n', '        _ensureApproval(peth, address(saiTub));\n', '\n', '        saiTub.lock(_cdpId, pethAmount);\n', '        emit CollateralSupplied(msg.sender, _cdpId, wethAmount, pethAmount);\n', '    }\n', '\n', '    function _return(bytes32 cdpId, uint wethAmount) internal returns (uint _wethAmount) {\n', '        uint pethAmount;\n', '\n', '        if (wethAmount == uint(- 1)) {\n', '            // return all collateral\n', '            pethAmount = saiTub.ink(cdpId);\n', '        } else {\n', '            pethAmount = pethForWeth(wethAmount);\n', '        }\n', '\n', '        saiTub.free(cdpId, pethAmount);\n', '\n', '        _ensureApproval(peth, address(saiTub));\n', '\n', '        saiTub.exit(pethAmount);\n', '\n', '        _wethAmount = wethForPeth(pethAmount);\n', '\n', '        emit CollateralReturned(msg.sender, cdpId, _wethAmount, pethAmount);\n', '    }\n', '\n', '    function _calcGovernanceFee(bytes32 cdpId, uint daiAmount) internal returns (uint mkrFeeAmount) {\n', '        uint daiFeeAmount = rmul(daiAmount, rdiv(saiTub.rap(cdpId), saiTub.tab(cdpId)));\n', '        (bytes32 val, bool ok) = saiTub.pep().peek();\n', "        require(ok && val != 0, 'Unable to get mkr rate');\n", '\n', '        return wdiv(daiFeeAmount, uint(val));\n', '    }\n', '\n', '    function _handleGovFee(uint mkrGovAmount, bool payWithDai) internal {\n', '        if (mkrGovAmount > 0) {\n', '            if (payWithDai) {\n', '                uint daiAmount = dex.getPayAmount(dai, mkr, mkrGovAmount);\n', '\n', '                _ensureApproval(dai, address(dex));\n', '\n', '                require(dai.transferFrom(msg.sender, address(this), daiAmount));\n', '                dex.buyAllAmount(mkr, mkrGovAmount, dai, daiAmount);\n', '            } else {\n', '                require(mkr.transferFrom(msg.sender, address(this), mkrGovAmount));\n', '            }\n', '        }\n', '    }\n', '\n', '    function _ensureApproval(IERC20 token, address spender) internal {\n', '        if (token.allowance(address(this), spender) != uint(- 1)) {\n', '            require(token.approve(spender, uint(- 1)));\n', '        }\n', '    }\n', '\n', '    function _createCdp() internal returns (bytes32 cdpId) {\n', '        cdpId = saiTub.open();\n', '\n', '        cdpOwner[cdpId] = msg.sender;\n', '        cdpsByOwner[msg.sender].push(cdpId);\n', '\n', '        emit CdpOpened(msg.sender, cdpId);\n', '    }\n', '    \n', '    function _removeCdp(bytes32 cdpId, address owner) internal {\n', '        (uint i, bool ok) = cdpsByOwner[owner].findElement(cdpId);\n', '        require(ok, "Can\'t find cdp in owner\'s list");\n', '        \n', '        cdpsByOwner[owner].removeElement(i);\n', '        delete cdpOwner[cdpId];\n', '    }\n', '}']