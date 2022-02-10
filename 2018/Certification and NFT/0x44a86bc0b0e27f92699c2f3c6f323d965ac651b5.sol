['/**\n', ' * Tokensale.sol\n', ' * Mt Pelerin Share (MPS) token sale : public phase.\n', '\n', ' * More info about MPS : https://github.com/MtPelerin/MtPelerin-share-MPS\n', '\n', ' * The unflattened code is available through this github tag:\n', ' * https://github.com/MtPelerin/MtPelerin-protocol/tree/etherscan-verify-batch-2\n', '\n', ' * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved\n', '\n', ' * @notice All matters regarding the intellectual property of this code \n', ' * @notice or software are subject to Swiss Law without reference to its \n', ' * @notice conflicts of law rules.\n', '\n', ' * @notice License for each contract is available in the respective file\n', ' * @notice or in the LICENSE.md file.\n', ' * @notice https://github.com/MtPelerin/\n', '\n', ' * @notice Code by OpenZeppelin is copyrighted and licensed on their repository:\n', ' * @notice https://github.com/OpenZeppelin/openzeppelin-solidity\n', ' */\n', '\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '// File: contracts/interface/IUserRegistry.sol\n', '\n', '/**\n', ' * @title IUserRegistry\n', ' * @dev IUserRegistry interface\n', ' * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>\n', ' *\n', ' * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved\n', ' * @notice Please refer to the top of this file for the license.\n', ' **/\n', 'contract IUserRegistry {\n', '\n', '  function registerManyUsers(address[] _addresses, uint256 _validUntilTime)\n', '    public;\n', '\n', '  function attachManyAddresses(uint256[] _userIds, address[] _addresses)\n', '    public;\n', '\n', '  function detachManyAddresses(address[] _addresses)\n', '    public;\n', '\n', '  function userCount() public view returns (uint256);\n', '  function userId(address _address) public view returns (uint256);\n', '  function addressConfirmed(address _address) public view returns (bool);\n', '  function validUntilTime(uint256 _userId) public view returns (uint256);\n', '  function suspended(uint256 _userId) public view returns (bool);\n', '  function extended(uint256 _userId, uint256 _key)\n', '    public view returns (uint256);\n', '\n', '  function isAddressValid(address _address) public view returns (bool);\n', '  function isValid(uint256 _userId) public view returns (bool);\n', '\n', '  function registerUser(address _address, uint256 _validUntilTime) public;\n', '  function attachAddress(uint256 _userId, address _address) public;\n', '  function confirmSelf() public;\n', '  function detachAddress(address _address) public;\n', '  function detachSelf() public;\n', '  function detachSelfAddress(address _address) public;\n', '  function suspendUser(uint256 _userId) public;\n', '  function unsuspendUser(uint256 _userId) public;\n', '  function suspendManyUsers(uint256[] _userIds) public;\n', '  function unsuspendManyUsers(uint256[] _userIds) public;\n', '  function updateUser(uint256 _userId, uint256 _validUntil, bool _suspended)\n', '    public;\n', '\n', '  function updateManyUsers(\n', '    uint256[] _userIds,\n', '    uint256 _validUntil,\n', '    bool _suspended) public;\n', '\n', '  function updateUserExtended(uint256 _userId, uint256 _key, uint256 _value)\n', '    public;\n', '\n', '  function updateManyUsersExtended(\n', '    uint256[] _userIds,\n', '    uint256 _key,\n', '    uint256 _value) public;\n', '}\n', '\n', '// File: contracts/interface/IRatesProvider.sol\n', '\n', '/**\n', ' * @title IRatesProvider\n', ' * @dev IRatesProvider interface\n', ' *\n', ' * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>\n', ' *\n', ' * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved\n', ' * @notice Please refer to the top of this file for the license.\n', ' */\n', 'contract IRatesProvider {\n', '  function rateWEIPerCHFCent() public view returns (uint256);\n', '  function convertWEIToCHFCent(uint256 _amountWEI)\n', '    public view returns (uint256);\n', '\n', '  function convertCHFCentToWEI(uint256 _amountCHFCent)\n', '    public view returns (uint256);\n', '}\n', '\n', '// File: contracts/zeppelin/token/ERC20/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: contracts/zeppelin/token/ERC20/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '// File: contracts/interface/ITokensale.sol\n', '\n', '/**\n', ' * @title ITokensale\n', ' * @dev ITokensale interface\n', ' *\n', ' * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>\n', ' *\n', ' * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved\n', ' * @notice Please refer to the top of this file for the license.\n', ' */\n', 'contract ITokensale {\n', '\n', '  function () external payable;\n', '\n', '  uint256 constant MINIMAL_AUTO_WITHDRAW = 0.5 ether;\n', '  uint256 constant MINIMAL_BALANCE = 0.5 ether;\n', '  uint256 constant MINIMAL_INVESTMENT = 50; // tokens\n', '  uint256 constant BASE_PRICE_CHF_CENT = 500;\n', '  uint256 constant KYC_LEVEL_KEY = 1;\n', '\n', '  function minimalAutoWithdraw() public view returns (uint256);\n', '  function minimalBalance() public view returns (uint256);\n', '  function basePriceCHFCent() public view returns (uint256);\n', '\n', '  /* General sale details */\n', '  function token() public view returns (ERC20);\n', '  function vaultETH() public view returns (address);\n', '  function vaultERC20() public view returns (address);\n', '  function userRegistry() public view returns (IUserRegistry);\n', '  function ratesProvider() public view returns (IRatesProvider);\n', '  function sharePurchaseAgreementHash() public view returns (bytes32);\n', '\n', '  /* Sale status */\n', '  function startAt() public view returns (uint256);\n', '  function endAt() public view returns (uint256);\n', '  function raisedETH() public view returns (uint256);\n', '  function raisedCHF() public view returns (uint256);\n', '  function totalRaisedCHF() public view returns (uint256);\n', '  function totalUnspentETH() public view returns (uint256);\n', '  function totalRefundedETH() public view returns (uint256);\n', '  function availableSupply() public view returns (uint256);\n', '\n', '  /* Investor specific attributes */\n', '  function investorUnspentETH(uint256 _investorId)\n', '    public view returns (uint256);\n', '\n', '  function investorInvestedCHF(uint256 _investorId)\n', '    public view returns (uint256);\n', '\n', '  function investorAcceptedSPA(uint256 _investorId)\n', '    public view returns (bool);\n', '\n', '  function investorAllocations(uint256 _investorId)\n', '    public view returns (uint256);\n', '\n', '  function investorTokens(uint256 _investorId) public view returns (uint256);\n', '  function investorCount() public view returns (uint256);\n', '\n', '  function investorLimit(uint256 _investorId) public view returns (uint256);\n', '\n', '  /* Share Purchase Agreement */\n', '  function defineSPA(bytes32 _sharePurchaseAgreementHash)\n', '    public returns (bool);\n', '\n', '  function acceptSPA(bytes32 _sharePurchaseAgreementHash)\n', '    public payable returns (bool);\n', '\n', '  /* Investment */\n', '  function investETH() public payable;\n', '  function addOffChainInvestment(address _investor, uint256 _amountCHF)\n', '    public;\n', '\n', '  /* Schedule */\n', '  function updateSchedule(uint256 _startAt, uint256 _endAt) public;\n', '\n', '  /* Allocations admin */\n', '  function allocateTokens(address _investor, uint256 _amount)\n', '    public returns (bool);\n', '\n', '  function allocateManyTokens(address[] _investors, uint256[] _amounts)\n', '    public returns (bool);\n', '\n', '  /* ETH administration */\n', '  function fundETH() public payable;\n', '  function refundManyUnspentETH(address[] _receivers) public;\n', '  function refundUnspentETH(address _receiver) public;\n', '  function withdrawETHFunds() public;\n', '\n', '  event SalePurchaseAgreementHash(bytes32 sharePurchaseAgreement);\n', '  event Allocation(\n', '    uint256 investorId,\n', '    uint256 tokens\n', '  );\n', '  event Investment(\n', '    uint256 investorId,\n', '    uint256 spentCHF\n', '  );\n', '  event ChangeETHCHF(\n', '    address investor,\n', '    uint256 amount,\n', '    uint256 converted,\n', '    uint256 rate\n', '  );\n', '  event FundETH(uint256 amount);\n', '  event WithdrawETH(address receiver, uint256 amount);\n', '}\n', '\n', '// File: contracts/zeppelin/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: contracts/zeppelin/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '// File: contracts/zeppelin/lifecycle/Pausable.sol\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '// File: contracts/Authority.sol\n', '\n', '/**\n', ' * @title Authority\n', ' * @dev The Authority contract has an authority address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' * Authority means to represent a legal entity that is entitled to specific rights\n', ' *\n', ' * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>\n', ' *\n', ' * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved\n', ' * @notice Please refer to the top of this file for the license.\n', ' *\n', ' * Error messages\n', ' * AU01: Message sender must be an authority\n', ' */\n', 'contract Authority is Ownable {\n', '\n', '  address authority;\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the authority.\n', '   */\n', '  modifier onlyAuthority {\n', '    require(msg.sender == authority, "AU01");\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the address associated to the authority\n', '   */\n', '  function authorityAddress() public view returns (address) {\n', '    return authority;\n', '  }\n', '\n', '  /** Define an address as authority, with an arbitrary name included in the event\n', '   * @dev returns the authority of the\n', '   * @param _name the authority name\n', '   * @param _address the authority address.\n', '   */\n', '  function defineAuthority(string _name, address _address) public onlyOwner {\n', '    emit AuthorityDefined(_name, _address);\n', '    authority = _address;\n', '  }\n', '\n', '  event AuthorityDefined(\n', '    string name,\n', '    address _address\n', '  );\n', '}\n', '\n', '// File: contracts/tokensale/Tokensale.sol\n', '\n', '/**\n', ' * @title Tokensale\n', ' * @dev Tokensale contract\n', ' *\n', ' * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>\n', ' *\n', ' * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved\n', ' * @notice Please refer to the top of this file for the license.\n', ' *\n', ' * Error messages\n', ' * TOS01: It must be before the sale is opened\n', ' * TOS02: Sale must be open\n', ' * TOS03: It must be before the sale is closed\n', ' * TOS04: It must be after the sale is closed\n', ' * TOS05: No data must be sent while sending ETH\n', ' * TOS06: Share Purchase Agreement Hashes must match\n', ' * TOS07: User/Investor must exist\n', ' * TOS08: SPA must be accepted before any ETH investment\n', ' * TOS09: Cannot update schedule once started\n', ' * TOS10: Investor must exist\n', ' * TOS11: Cannot allocate more tokens than available supply\n', ' * TOS12: Length of InvestorIds and amounts arguments must match\n', ' * TOS13: Investor must exist\n', ' * TOS14: Must refund ETH unspent\n', ' * TOS15: Must withdraw ETH to vaultETH\n', ' * TOS16: Cannot invest onchain and offchain at the same time\n', ' * TOS17: A ETHCHF rate must exist to invest\n', ' * TOS18: User must be valid\n', ' * TOS19: Cannot invest if no tokens are available\n', ' * TOS20: Investment is below the minimal investment\n', ' * TOS21: Cannot unspend more CHF than BASE_TOKEN_PRICE_CHF\n', ' * TOS22: Token transfer must be successful\n', ' */\n', 'contract Tokensale is ITokensale, Authority, Pausable {\n', '  using SafeMath for uint256;\n', '\n', '  uint32[5] contributionLimits = [\n', '    5000,\n', '    500000,\n', '    1500000,\n', '    10000000,\n', '    25000000\n', '  ];\n', '\n', '  /* General sale details */\n', '  ERC20 public token;\n', '  address public vaultETH;\n', '  address public vaultERC20;\n', '  IUserRegistry public userRegistry;\n', '  IRatesProvider public ratesProvider;\n', '\n', '  uint256 public minimalBalance = MINIMAL_BALANCE;\n', '  bytes32 public sharePurchaseAgreementHash;\n', '\n', '  uint256 public startAt = 4102441200;\n', '  uint256 public endAt = 4102441200;\n', '  uint256 public raisedETH;\n', '  uint256 public raisedCHF;\n', '  uint256 public totalRaisedCHF;\n', '  uint256 public totalUnspentETH;\n', '  uint256 public totalRefundedETH;\n', '  uint256 public allocatedTokens;\n', '\n', '  struct Investor {\n', '    uint256 unspentETH;\n', '    uint256 investedCHF;\n', '    bool acceptedSPA;\n', '    uint256 allocations;\n', '    uint256 tokens;\n', '  }\n', '  mapping(uint256 => Investor) investors;\n', '  mapping(uint256 => uint256) investorLimits;\n', '  uint256 public investorCount;\n', '\n', '  /**\n', '   * @dev Throws unless before sale opening\n', '   */\n', '  modifier beforeSaleIsOpened {\n', '    require(currentTime() < startAt, "TOS01");\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if sale is not open\n', '   */\n', '  modifier saleIsOpened {\n', '    require(currentTime() >= startAt && currentTime() <= endAt, "TOS02");\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws once the sale is closed\n', '   */\n', '  modifier beforeSaleIsClosed {\n', '    require(currentTime() <= endAt, "TOS03");\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev constructor\n', '   */\n', '  constructor(\n', '    ERC20 _token,\n', '    IUserRegistry _userRegistry,\n', '    IRatesProvider _ratesProvider,\n', '    address _vaultERC20,\n', '    address _vaultETH\n', '  ) public\n', '  {\n', '    token = _token;\n', '    userRegistry = _userRegistry;\n', '    ratesProvider = _ratesProvider;\n', '    vaultERC20 = _vaultERC20;\n', '    vaultETH = _vaultETH;\n', '  }\n', '\n', '  /**\n', '   * @dev fallback function\n', '   */\n', '  function () external payable {\n', '    require(msg.data.length == 0, "TOS05");\n', '    investETH();\n', '  }\n', '\n', '  /**\n', '   * @dev returns the token sold\n', '   */\n', '  function token() public view returns (ERC20) {\n', '    return token;\n', '  }\n', '\n', '  /**\n', '   * @dev returns the vault use to\n', '   */\n', '  function vaultETH() public view returns (address) {\n', '    return vaultETH;\n', '  }\n', '\n', '  /**\n', '   * @dev returns the vault to receive ETH\n', '   */\n', '  function vaultERC20() public view returns (address) {\n', '    return vaultERC20;\n', '  }\n', '\n', '  function userRegistry() public view returns (IUserRegistry) {\n', '    return userRegistry;\n', '  }\n', '\n', '  function ratesProvider() public view returns (IRatesProvider) {\n', '    return ratesProvider;\n', '  }\n', '\n', '  function sharePurchaseAgreementHash() public view returns (bytes32) {\n', '    return sharePurchaseAgreementHash;\n', '  }\n', '\n', '  /* Sale status */\n', '  function startAt() public view returns (uint256) {\n', '    return startAt;\n', '  }\n', '\n', '  function endAt() public view returns (uint256) {\n', '    return endAt;\n', '  }\n', '\n', '  function raisedETH() public view returns (uint256) {\n', '    return raisedETH;\n', '  }\n', '\n', '  function raisedCHF() public view returns (uint256) {\n', '    return raisedCHF;\n', '  }\n', '\n', '  function totalRaisedCHF() public view returns (uint256) {\n', '    return totalRaisedCHF;\n', '  }\n', '\n', '  function totalUnspentETH() public view returns (uint256) {\n', '    return totalUnspentETH;\n', '  }\n', '\n', '  function totalRefundedETH() public view returns (uint256) {\n', '    return totalRefundedETH;\n', '  }\n', '\n', '  function availableSupply() public view returns (uint256) {\n', '    uint256 vaultSupply = token.balanceOf(vaultERC20);\n', '    uint256 allowance = token.allowance(vaultERC20, address(this));\n', '    return (vaultSupply < allowance) ? vaultSupply : allowance;\n', '  }\n', ' \n', '  /* Investor specific attributes */\n', '  function investorUnspentETH(uint256 _investorId)\n', '    public view returns (uint256)\n', '  {\n', '    return investors[_investorId].unspentETH;\n', '  }\n', '\n', '  function investorInvestedCHF(uint256 _investorId)\n', '    public view returns (uint256)\n', '  {\n', '    return investors[_investorId].investedCHF;\n', '  }\n', '\n', '  function investorAcceptedSPA(uint256 _investorId)\n', '    public view returns (bool)\n', '  {\n', '    return investors[_investorId].acceptedSPA;\n', '  }\n', '\n', '  function investorAllocations(uint256 _investorId)\n', '    public view returns (uint256)\n', '  {\n', '    return investors[_investorId].allocations;\n', '  }\n', '\n', '  function investorTokens(uint256 _investorId) public view returns (uint256) {\n', '    return investors[_investorId].tokens;\n', '  }\n', '\n', '  function investorCount() public view returns (uint256) {\n', '    return investorCount;\n', '  }\n', '\n', '  function investorLimit(uint256 _investorId) public view returns (uint256) {\n', '    return investorLimits[_investorId];\n', '  }\n', '\n', '  /**\n', '   * @dev get minimak auto withdraw threshold\n', '   */\n', '  function minimalAutoWithdraw() public view returns (uint256) {\n', '    return MINIMAL_AUTO_WITHDRAW;\n', '  }\n', '\n', '  /**\n', '   * @dev get minimal balance to maintain in contract\n', '   */\n', '  function minimalBalance() public view returns (uint256) {\n', '    return minimalBalance;\n', '  }\n', '\n', '  /**\n', '   * @dev get base price in CHF cents\n', '   */\n', '  function basePriceCHFCent() public view returns (uint256) {\n', '    return BASE_PRICE_CHF_CENT;\n', '  }\n', '\n', '  /**\n', '   * @dev contribution limit based on kyc level\n', '   */\n', '  function contributionLimit(uint256 _investorId)\n', '    public view returns (uint256)\n', '  {\n', '    uint256 kycLevel = userRegistry.extended(_investorId, KYC_LEVEL_KEY);\n', '    uint256 limit = 0;\n', '    if (kycLevel < 5) {\n', '      limit = contributionLimits[kycLevel];\n', '    } else {\n', '      limit = (investorLimits[_investorId] > 0\n', '        ) ? investorLimits[_investorId] : contributionLimits[4];\n', '    }\n', '    return limit.sub(investors[_investorId].investedCHF);\n', '  }\n', '\n', '  /**\n', '   * @dev update minimal balance to be kept in contract\n', '   */\n', '  function updateMinimalBalance(uint256 _minimalBalance)\n', '    public returns (uint256)\n', '  {\n', '    minimalBalance = _minimalBalance;\n', '  }\n', '\n', '  /**\n', '   * @dev define investor limit\n', '   */\n', '  function updateInvestorLimits(uint256[] _investorIds, uint256 _limit)\n', '    public returns (uint256)\n', '  {\n', '    for (uint256 i = 0; i < _investorIds.length; i++) {\n', '      investorLimits[_investorIds[i]] = _limit;\n', '    }\n', '  }\n', '\n', '  /* Share Purchase Agreement */\n', '  /**\n', '   * @dev define SPA\n', '   */\n', '  function defineSPA(bytes32 _sharePurchaseAgreementHash)\n', '    public onlyOwner returns (bool)\n', '  {\n', '    sharePurchaseAgreementHash = _sharePurchaseAgreementHash;\n', '    emit SalePurchaseAgreementHash(_sharePurchaseAgreementHash);\n', '  }\n', '\n', '  /**\n', '   * @dev Accept SPA and invest if msg.value > 0\n', '   */\n', '  function acceptSPA(bytes32 _sharePurchaseAgreementHash)\n', '    public beforeSaleIsClosed payable returns (bool)\n', '  {\n', '    require(\n', '      _sharePurchaseAgreementHash == sharePurchaseAgreementHash, "TOS06");\n', '    uint256 investorId = userRegistry.userId(msg.sender);\n', '    require(investorId > 0, "TOS07");\n', '    investors[investorId].acceptedSPA = true;\n', '    investorCount++;\n', '\n', '    if (msg.value > 0) {\n', '      investETH();\n', '    }\n', '  }\n', '\n', '  /* Investment */\n', '  function investETH() public\n', '    saleIsOpened whenNotPaused payable\n', '  {\n', '    //Accepting SharePurchaseAgreement is temporarily offchain\n', '    //uint256 investorId = userRegistry.userId(msg.sender);\n', '    //require(investors[investorId].acceptedSPA, "TOS08");\n', '    investInternal(msg.sender, msg.value, 0);\n', '    withdrawETHFundsInternal();\n', '  }\n', '\n', '  /**\n', '   * @dev add off chain investment\n', '   */\n', '  function addOffChainInvestment(address _investor, uint256 _amountCHF)\n', '    public onlyAuthority\n', '  {\n', '    investInternal(_investor, 0, _amountCHF);\n', '  }\n', '\n', '  /* Schedule */ \n', '  /**\n', '   * @dev update schedule\n', '   */\n', '  function updateSchedule(uint256 _startAt, uint256 _endAt)\n', '    public onlyAuthority beforeSaleIsOpened\n', '  {\n', '    require(_startAt < _endAt, "TOS09");\n', '    startAt = _startAt;\n', '    endAt = _endAt;\n', '  }\n', '\n', '  /* Allocations admin */\n', '  /**\n', '   * @dev allocate\n', '   */\n', '  function allocateTokens(address _investor, uint256 _amount)\n', '    public onlyAuthority beforeSaleIsClosed returns (bool)\n', '  {\n', '    uint256 investorId = userRegistry.userId(_investor);\n', '    require(investorId > 0, "TOS10");\n', '    Investor storage investor = investors[investorId];\n', '    \n', '    allocatedTokens = allocatedTokens.sub(investor.allocations).add(_amount);\n', '    require(allocatedTokens <= availableSupply(), "TOS11");\n', '\n', '    investor.allocations = _amount;\n', '    emit Allocation(investorId, _amount);\n', '  }\n', '\n', '  /**\n', '   * @dev allocate many\n', '   */\n', '  function allocateManyTokens(address[] _investors, uint256[] _amounts)\n', '    public onlyAuthority beforeSaleIsClosed returns (bool)\n', '  {\n', '    require(_investors.length == _amounts.length, "TOS12");\n', '    for (uint256 i = 0; i < _investors.length; i++) {\n', '      allocateTokens(_investors[i], _amounts[i]);\n', '    }\n', '  }\n', '\n', '  /* ETH administration */\n', '  /**\n', '   * @dev fund ETH\n', '   */\n', '  function fundETH() public payable onlyAuthority {\n', '    emit FundETH(msg.value);\n', '  }\n', '\n', '  /**\n', '   * @dev refund unspent ETH many\n', '   */\n', '  function refundManyUnspentETH(address[] _receivers) public onlyAuthority {\n', '    for (uint256 i = 0; i < _receivers.length; i++) {\n', '      refundUnspentETH(_receivers[i]);\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev refund unspent ETH\n', '   */\n', '  function refundUnspentETH(address _receiver) public onlyAuthority {\n', '    uint256 investorId = userRegistry.userId(_receiver);\n', '    require(investorId != 0, "TOS13");\n', '    Investor storage investor = investors[investorId];\n', '\n', '    if (investor.unspentETH > 0) {\n', '      // solium-disable-next-line security/no-send\n', '      require(_receiver.send(investor.unspentETH), "TOS14");\n', '      totalRefundedETH = totalRefundedETH.add(investor.unspentETH);\n', '      emit WithdrawETH(_receiver, investor.unspentETH);\n', '      totalUnspentETH = totalUnspentETH.sub(investor.unspentETH);\n', '      investor.unspentETH = 0;\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev withdraw ETH funds\n', '   */\n', '  function withdrawETHFunds() public onlyAuthority {\n', '    withdrawETHFundsInternal();\n', '  }\n', '\n', '  /**\n', '   * @dev withdraw all ETH funds\n', '   */\n', '  function withdrawAllETHFunds() public onlyAuthority {\n', '    uint256 balance = address(this).balance;\n', '    // solium-disable-next-line security/no-send\n', '    require(vaultETH.send(balance), "TOS15");\n', '    emit WithdrawETH(vaultETH, balance);\n', '  }\n', '\n', '  /**\n', '   * @dev allowed token investment\n', '   */\n', '  function allowedTokenInvestment(\n', '    uint256 _investorId, uint256 _contributionCHF)\n', '    public view returns (uint256)\n', '  {\n', '    uint256 tokens = 0;\n', '    uint256 allowedContributionCHF = contributionLimit(_investorId);\n', '    if (_contributionCHF < allowedContributionCHF) {\n', '      allowedContributionCHF = _contributionCHF;\n', '    }\n', '    tokens = allowedContributionCHF.div(BASE_PRICE_CHF_CENT);\n', '    uint256 availableTokens = availableSupply().sub(\n', '      allocatedTokens).add(investors[_investorId].allocations);\n', '    if (tokens > availableTokens) {\n', '      tokens = availableTokens;\n', '    }\n', '    if (tokens < MINIMAL_INVESTMENT) {\n', '      tokens = 0;\n', '    }\n', '    return tokens;\n', '  }\n', '\n', '  /**\n', '   * @dev withdraw ETH funds internal\n', '   */\n', '  function withdrawETHFundsInternal() internal {\n', '    uint256 balance = address(this).balance;\n', '\n', '    if (balance > totalUnspentETH && balance > minimalBalance) {\n', '      uint256 amount = balance.sub(minimalBalance);\n', '      // solium-disable-next-line security/no-send\n', '      require(vaultETH.send(amount), "TOS15");\n', '      emit WithdrawETH(vaultETH, amount);\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev invest internal\n', '   */\n', '  function investInternal(\n', '    address _investor, uint256 _amountETH, uint256 _amountCHF)\n', '    private\n', '  {\n', '    // investment with _amountETH is decentralized\n', '    // investment with _amountCHF is centralized\n', '    // They are mutually exclusive\n', '    bool isInvesting = (\n', '        _amountETH != 0 && _amountCHF == 0\n', '      ) || (\n', '      _amountETH == 0 && _amountCHF != 0\n', '      );\n', '    require(isInvesting, "TOS16");\n', '    require(ratesProvider.rateWEIPerCHFCent() != 0, "TOS17");\n', '    uint256 investorId = userRegistry.userId(_investor);\n', '    require(userRegistry.isValid(investorId), "TOS18");\n', '\n', '    Investor storage investor = investors[investorId];\n', '\n', '    uint256 contributionCHF = ratesProvider.convertWEIToCHFCent(\n', '      investor.unspentETH);\n', '\n', '    if (_amountETH > 0) {\n', '      contributionCHF = contributionCHF.add(\n', '        ratesProvider.convertWEIToCHFCent(_amountETH));\n', '    }\n', '    if (_amountCHF > 0) {\n', '      contributionCHF = contributionCHF.add(_amountCHF);\n', '    }\n', '\n', '    uint256 tokens = allowedTokenInvestment(investorId, contributionCHF);\n', '    require(tokens != 0, "TOS19");\n', '\n', '    /** Calculating unspentETH value **/\n', '    uint256 investedCHF = tokens.mul(BASE_PRICE_CHF_CENT);\n', '    uint256 unspentContributionCHF = contributionCHF.sub(investedCHF);\n', '\n', '    uint256 unspentETH = 0;\n', '    if (unspentContributionCHF != 0) {\n', '      if (_amountCHF > 0) {\n', '        // Prevent CHF investment LARGER than available supply\n', '        // from creating a too large and dangerous unspentETH value\n', '        require(unspentContributionCHF < BASE_PRICE_CHF_CENT, "TOS21");\n', '      }\n', '      unspentETH = ratesProvider.convertCHFCentToWEI(\n', '        unspentContributionCHF);\n', '    }\n', '\n', '    /** Spent ETH **/\n', '    uint256 spentETH = 0;\n', '    if (investor.unspentETH == unspentETH) {\n', '      spentETH = _amountETH;\n', '    } else {\n', '      uint256 unspentETHDiff = (unspentETH > investor.unspentETH)\n', '        ? unspentETH.sub(investor.unspentETH)\n', '        : investor.unspentETH.sub(unspentETH);\n', '\n', '      if (_amountCHF > 0) {\n', '        if (unspentETH < investor.unspentETH) {\n', '          spentETH = unspentETHDiff;\n', '        }\n', '        // if unspentETH > investor.unspentETH\n', '        // then CHF has been converted into ETH\n', '        // and no ETH were spent\n', '      }\n', '      if (_amountETH > 0) {\n', '        spentETH = (unspentETH > investor.unspentETH)\n', '          ? _amountETH.sub(unspentETHDiff)\n', '          : _amountETH.add(unspentETHDiff);\n', '      }\n', '    }\n', '\n', '    totalUnspentETH = totalUnspentETH.sub(\n', '      investor.unspentETH).add(unspentETH);\n', '    investor.unspentETH = unspentETH;\n', '    investor.investedCHF = investor.investedCHF.add(investedCHF);\n', '    investor.tokens = investor.tokens.add(tokens);\n', '    raisedCHF = raisedCHF.add(_amountCHF);\n', '    raisedETH = raisedETH.add(spentETH);\n', '    totalRaisedCHF = totalRaisedCHF.add(investedCHF);\n', '\n', '    allocatedTokens = allocatedTokens.sub(investor.allocations);\n', '    investor.allocations = (investor.allocations > tokens)\n', '      ? investor.allocations.sub(tokens) : 0;\n', '    allocatedTokens = allocatedTokens.add(investor.allocations);\n', '    require(\n', '      token.transferFrom(vaultERC20, _investor, tokens),\n', '      "TOS22");\n', '\n', '    if (spentETH > 0) {\n', '      emit ChangeETHCHF(\n', '        _investor,\n', '        spentETH,\n', '        ratesProvider.convertWEIToCHFCent(spentETH),\n', '        ratesProvider.rateWEIPerCHFCent());\n', '    }\n', '    emit Investment(investorId, investedCHF);\n', '  }\n', '\n', '  /* Util */\n', '  /**\n', '   * @dev current time\n', '   */\n', '  function currentTime() private view returns (uint256) {\n', '    // solium-disable-next-line security/no-block-members\n', '    return now;\n', '  }\n', '}']