['pragma solidity 0.5.17;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'interface IUniswap {\n', '  // To convert DAI to ETH\n', '  function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);\n', '  // To convert ETH to YELD and burn it\n', '  function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);\n', '}\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract Context {\n', '    constructor () internal { }\n', '    // solhint-disable-previous-line no-empty-blocks\n', '\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'contract Ownable is Context {\n', '    address payable private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    constructor () internal {\n', '        _owner = _msgSender();\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '    function owner() public view returns (address payable) {\n', '        return _owner;\n', '    }\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '    function isOwner() public view returns (bool) {\n', '        return _msgSender() == _owner;\n', '    }\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '    function transferOwnership(address payable newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '    function _transferOwnership(address payable newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract ERC20 is Context, IERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '\n', '    uint256 _totalSupply;\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '    function balanceOf(address account) public view returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '    function transfer(address recipient, uint256 amount) public returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '    function approve(address spender, uint256 amount) public returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', '    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\n', '        return true;\n', '    }\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));\n', '        return true;\n', '    }\n', '    function _transfer(address sender, address recipient, uint256 amount) internal {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '    function _mint(address account, uint256 amount) internal {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '    function _burn(address account, uint256 amount) internal {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '    function _approve(address owner, address spender, uint256 amount) internal {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '    function _burnFrom(address account, uint256 amount) internal {\n', '        _burn(account, amount);\n', '        _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));\n', '    }\n', '}\n', '\n', 'contract ERC20Detailed is IERC20 {\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '    constructor (string memory name, string memory symbol, uint8 decimals) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = decimals;\n', '    }\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '}\n', '\n', 'contract ReentrancyGuard {\n', '    uint256 private _guardCounter;\n', '\n', '    constructor () internal {\n', '        _guardCounter = 1;\n', '    }\n', '\n', '    modifier nonReentrant() {\n', '        _guardCounter += 1;\n', '        uint256 localCounter = _guardCounter;\n', '        _;\n', '        require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != 0x0 && codehash != accountHash);\n', '    }\n', '    function toPayable(address account) internal pure returns (address payable) {\n', '        return address(uint160(account));\n', '    }\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-call-value\n', '        (bool success, ) = recipient.call.value(amount)("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '}\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', 'interface Compound {\n', '    function mint ( uint256 mintAmount ) external returns ( uint256 );\n', '    function redeem(uint256 redeemTokens) external returns (uint256);\n', '    function exchangeRateStored() external view returns (uint);\n', '}\n', '\n', 'interface Fulcrum {\n', '    function mint(address receiver, uint256 amount) external payable returns (uint256 mintAmount);\n', '    function burn(address receiver, uint256 burnAmount) external returns (uint256 loanAmountPaid);\n', '    function assetBalanceOf(address _owner) external view returns (uint256 balance);\n', '}\n', '\n', 'interface ILendingPoolAddressesProvider {\n', '    function getLendingPool() external view returns (address);\n', '}\n', '\n', 'interface Aave {\n', '    function deposit(address _reserve, uint256 _amount, uint16 _referralCode) external;\n', '}\n', '\n', 'interface AToken {\n', '    function redeem(uint256 amount) external;\n', '}\n', '\n', 'interface IIEarnManager {\n', '    function recommend(address _token) external view returns (\n', '      string memory choice,\n', '      uint256 capr,\n', '      uint256 iapr,\n', '      uint256 aapr,\n', '      uint256 dapr\n', '    );\n', '}\n', '\n', 'contract Structs {\n', '    struct Val {\n', '        uint256 value;\n', '    }\n', '\n', '    enum ActionType {\n', '        Deposit,   // supply tokens\n', '        Withdraw  // borrow tokens\n', '    }\n', '\n', '    enum AssetDenomination {\n', '        Wei // the amount is denominated in wei\n', '    }\n', '\n', '    enum AssetReference {\n', '        Delta // the amount is given as a delta from the current value\n', '    }\n', '\n', '    struct AssetAmount {\n', '        bool sign; // true if positive\n', '        AssetDenomination denomination;\n', '        AssetReference ref;\n', '        uint256 value;\n', '    }\n', '\n', '    struct ActionArgs {\n', '        ActionType actionType;\n', '        uint256 accountId;\n', '        AssetAmount amount;\n', '        uint256 primaryMarketId;\n', '        uint256 secondaryMarketId;\n', '        address otherAddress;\n', '        uint256 otherAccountId;\n', '        bytes data;\n', '    }\n', '\n', '    struct Info {\n', '        address owner;  // The address that owns the account\n', '        uint256 number; // A nonce that allows a single address to control many accounts\n', '    }\n', '\n', '    struct Wei {\n', '        bool sign; // true if positive\n', '        uint256 value;\n', '    }\n', '}\n', '\n', 'contract DyDx is Structs {\n', '    function getAccountWei(Info memory account, uint256 marketId) public view returns (Wei memory);\n', '    function operate(Info[] memory, ActionArgs[] memory) public;\n', '}\n', '\n', 'interface LendingPoolAddressesProvider {\n', '    function getLendingPool() external view returns (address);\n', '    function getLendingPoolCore() external view returns (address);\n', '}\n', '\n', 'contract yTUSD is ERC20, ERC20Detailed, ReentrancyGuard, Structs, Ownable {\n', '  using SafeERC20 for IERC20;\n', '  using Address for address;\n', '  using SafeMath for uint256;\n', '\n', '  struct Deposit {\n', '    uint256 amount;\n', '    uint256 start; // Block when it started\n', '  }\n', '\n', '  uint256 public pool;\n', '  address public token;\n', '  address public compound;\n', '  address public fulcrum;\n', '  address public aave;\n', '  address public aavePool;\n', '  address public aaveToken;\n', '  address public dydx;\n', '  uint256 public dToken;\n', '  address public apr;\n', '  address public chai;\n', '  // Add other tokens if implemented for another stablecoin\n', '  address public uniswapRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;\n', '  address public tusd = 0x0000000000085d4780B73119b644AE5ecd22b376;\n', '  address public weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;\n', '  address payable public retirementYeldTreasury;\n', '  IERC20 public yeldToken;\n', '  uint256 public maximumTokensToBurn = 50000 * 1e18;\n', '  uint256 public constant minimumEffectAmount = 5 * 10 ** 18;\n', '  \n', '  // When you stake say 1000 TUSD for a day that will be your maximum\n', '  // if you stake the next time 300 TUSD your maximum will stay the same\n', '  // if you stake 2000 at once it will increase to 2000 TUSD\n', '  mapping(bytes32 => uint256) public numberOfParticipants;\n', '\n', '\n', '  mapping(address => Deposit) public deposits;\n', '  uint256 public constant oneDayInBlocks = 6500;\n', '  uint256 public yeldToRewardPerDay = 100e18; // 100 YELD per day per 1 million stablecoins padded with 18 zeroes to have that flexibility\n', '  uint256 public constant oneMillion = 1e6;\n', '\n', '\n', '  enum Lender {\n', '      NONE,\n', '      DYDX,\n', '      COMPOUND,\n', '      AAVE,\n', '      FULCRUM\n', '  }\n', '\n', '  Lender public provider = Lender.NONE;\n', '\n', '  constructor (address _yeldToken, address payable _retirementYeldTreasury) public payable ERC20Detailed("yearn TUSD", "yTUSD", 18) {\n', '    token = address(0x0000000000085d4780B73119b644AE5ecd22b376);\n', '    apr = address(0xdD6d648C991f7d47454354f4Ef326b04025a48A8);\n', '    dydx = address(0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e);\n', '    aave = address(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);\n', '    aavePool = address(0x3dfd23A6c5E8BbcFc9581d2E864a68feb6a076d3);\n', '    fulcrum = address(0x493C57C4763932315A328269E1ADaD09653B9081);\n', '    aaveToken = address(0xfC1E690f61EFd961294b3e1Ce3313fBD8aa4f85d);\n', '    compound = address(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);\n', '    chai = address(0x06AF07097C9Eeb7fD685c692751D5C66dB49c215);\n', '    dToken = 3;\n', '    yeldToken = IERC20(_yeldToken);\n', '    retirementYeldTreasury = _retirementYeldTreasury;\n', '    approveToken();\n', '  }\n', '\n', '  // To receive ETH after converting it from TUSD\n', '  function () external payable {}\n', '\n', '  function setRetirementYeldTreasury(address payable _treasury) public onlyOwner {\n', '    retirementYeldTreasury = _treasury;\n', '  }\n', '\n', '  // In case a new uniswap router version is released\n', '  function setUniswapRouter(address _uniswapRouter) public onlyOwner {\n', '    uniswapRouter = _uniswapRouter;\n', '  }\n', '\n', '  function extractTokensIfStuck(address _token, uint256 _amount) public onlyOwner {\n', '    IERC20(_token).transfer(msg.sender, _amount);\n', '  }\n', '\n', '  function extractETHIfStuck() public onlyOwner {\n', '    owner().transfer(address(this).balance);\n', '  }\n', '\n', '  function changeYeldToRewardPerDay(uint256 _amount) public onlyOwner {\n', '    yeldToRewardPerDay = _amount;\n', '  }\n', '\n', '  function getGeneratedYelds() public view returns(uint256) {\n', '    uint256 blocksPassed;\n', '    if (deposits[msg.sender].start > 0) {\n', '      blocksPassed = block.number.sub(deposits[msg.sender].start);\n', '    } else {\n', '      blocksPassed = 0;\n', '    }\n', '    // This will work because amount is a token with 18 decimals\n', '    // Take the deposit, reduce it by 1 million (by removing 6 zeroes) so you get 1\n', '    // That 1 means get 1 YELD per day (in blocks). Now multiply that 1 by 100 to get 100 YELD per day\n', '    //                       your deposits in dai       div by 1 million * by yeld to reward / 1e18 since yeldToReward is in 18 decimals to be able to provide a smaller price since\n', "    // we can't go below 1 in a variable. You can't make the price 0.00001 that's why we need that 1e18 padding\n", '    uint256 generatedYelds = deposits[msg.sender].amount.div(oneMillion).mul(yeldToRewardPerDay.div(1e18)).mul(blocksPassed).div(oneDayInBlocks);\n', '    return generatedYelds;\n', '  }\n', '\n', '  function extractYELDEarningsWhileKeepingDeposit() public {\n', "    require(deposits[msg.sender].start > 0 && deposits[msg.sender].amount > 0, 'Must have deposited stablecoins beforehand');\n", '    uint256 generatedYelds = getGeneratedYelds();\n', '    deposits[msg.sender] = Deposit(deposits[msg.sender].amount, block.number);\n', '    yeldToken.transfer(msg.sender, generatedYelds);\n', '  }\n', '\n', '  function deposit(uint256 _amount)\n', '      external\n', '      nonReentrant\n', '  {\n', '    require(_amount > 0, "deposit must be greater than 0");\n', '    pool = calcPoolValueInToken();\n', '    IERC20(token).safeTransferFrom(msg.sender, address(this), _amount);\n', '\n', '    // Yeld\n', '    uint256 userYeldBalance = yeldToken.balanceOf(msg.sender);\n', '    uint256 amountFivePercent = _amount.mul(5).div(100);\n', "    require(userYeldBalance >= amountFivePercent, 'Your YELD balance must be 5% or higher of the amount to deposit');\n", '    if (getGeneratedYelds() > 0) extractYELDEarningsWhileKeepingDeposit();\n', '    deposits[msg.sender] = Deposit(deposits[msg.sender].amount.add(_amount), block.number);\n', '    // Yeld\n', '\n', '    // Calculate pool shares\n', '    uint256 shares = 0;\n', '    if (pool == 0) {\n', '      shares = _amount;\n', '      pool = _amount;\n', '    } else {\n', '      shares = (_amount.mul(_totalSupply)).div(pool);\n', '    }\n', '    pool = calcPoolValueInToken();\n', '    _mint(msg.sender, shares);\n', '  }\n', '\n', '  // Converts TUSD to ETH and returns how much ETH has been received from Uniswap\n', '  function tusdToETH(uint256 _amount) internal returns(uint256) {\n', '      IERC20(tusd).safeApprove(uniswapRouter, 0);\n', '      IERC20(tusd).safeApprove(uniswapRouter, _amount);\n', '      address[] memory path = new address[](2);\n', '      path[0] = tusd;\n', '      path[1] = weth;\n', '      // swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)\n', "      // 'amounts' is an array where [0] is input TUSD amount and [1] is the resulting ETH after the conversion\n", "      // even tho we've specified the WETH address, we'll receive ETH since that's how it works on uniswap\n", '      // https://uniswap.org/docs/v2/smart-contracts/router02/#swapexacttokensforeth\n', '      uint[] memory amounts = IUniswap(uniswapRouter).swapExactTokensForETH(_amount, uint(0), path, address(this), now.add(1800));\n', '      return amounts[1];\n', '  }\n', '\n', '  // Buys YELD tokens paying in ETH on Uniswap and removes them from circulation\n', '  // Returns how many YELD tokens have been burned\n', '  function buyNBurn(uint256 _ethToSwap) internal returns(uint256) {\n', '    address[] memory path = new address[](2);\n', '    path[0] = weth;\n', '    path[1] = address(yeldToken);\n', '    // Burns the tokens by taking them out of circulation, sending them to the 0x0 address\n', '    uint[] memory amounts = IUniswap(uniswapRouter).swapExactETHForTokens.value(_ethToSwap)(uint(0), path, address(0), now.add(1800));\n', '    return amounts[1];\n', '  }\n', '\n', '  // No rebalance implementation for lower fees and faster swaps\n', '  function withdraw(uint256 _shares)\n', '      external\n', '      nonReentrant\n', '  {\n', '      require(_shares > 0, "withdraw must be greater than 0");\n', '      uint256 ibalance = balanceOf(msg.sender);\n', '      require(_shares <= ibalance, "insufficient balance");\n', '      pool = calcPoolValueInToken();\n', '      uint256 r = (pool.mul(_shares)).div(_totalSupply);\n', '      _balances[msg.sender] = _balances[msg.sender].sub(_shares, "redeem amount exceeds balance");\n', '      _totalSupply = _totalSupply.sub(_shares);\n', '      emit Transfer(msg.sender, address(0), _shares);\n', '      uint256 b = IERC20(token).balanceOf(address(this));\n', '      if (b < r) {\n', '        _withdrawSome(r.sub(b));\n', '      }\n', '\n', '      // Yeld\n', '      uint256 generatedYelds = getGeneratedYelds();\n', "      uint256 halfProfits = (r.sub(deposits[msg.sender].amount, '#3 Half profits sub error')).div(2);\n", '      deposits[msg.sender] = Deposit(deposits[msg.sender].amount.sub(_shares), block.number);\n', '      yeldToken.transfer(msg.sender, generatedYelds);\n', '\n', '      // Take a portion of the profits for the buy and burn and retirement yeld\n', '      // Convert half the TUSD earned into ETH for the protocol algorithms\n', '      if (halfProfits > minimumEffectAmount) {\n', '        uint256 stakingProfits = tusdToETH(halfProfits);\n', '        uint256 tokensAlreadyBurned = yeldToken.balanceOf(address(0));\n', '        if (tokensAlreadyBurned < maximumTokensToBurn) {\n', '          // 98% is the 49% doubled since we already took the 50%\n', '          uint256 ethToSwap = stakingProfits.mul(98).div(100);\n', '          // Buy and burn only applies up to 50k tokens burned\n', '          buyNBurn(ethToSwap);\n', '          // 1% for the Retirement Yield\n', '          uint256 retirementYeld = stakingProfits.mul(2).div(100);\n', '          // Send to the treasury\n', '          retirementYeldTreasury.transfer(retirementYeld);\n', '        } else {\n', "          // If we've reached the maximum burn point, send half the profits to the treasury to reward holders\n", '          uint256 retirementYeld = stakingProfits;\n', '          // Send to the treasury\n', '          retirementYeldTreasury.transfer(retirementYeld);\n', '        }\n', '      }\n', '      // Yeld\n', '\n', '      IERC20(token).safeTransfer(msg.sender, r);\n', '      pool = calcPoolValueInToken();\n', '  }\n', '\n', '  function recommend() public view returns (Lender) {\n', '    (,uint256 capr,uint256 iapr,uint256 aapr,uint256 dapr) = IIEarnManager(apr).recommend(token);\n', '    uint256 max = 0;\n', '    if (capr > max) {\n', '      max = capr;\n', '    }\n', '    if (iapr > max) {\n', '      max = iapr;\n', '    }\n', '    if (aapr > max) {\n', '      max = aapr;\n', '    }\n', '    if (dapr > max) {\n', '      max = dapr;\n', '    }\n', '\n', '    Lender newProvider = Lender.NONE;\n', '    if (max == capr) {\n', '      newProvider = Lender.COMPOUND;\n', '    } else if (max == iapr) {\n', '      newProvider = Lender.FULCRUM;\n', '    } else if (max == aapr) {\n', '      newProvider = Lender.AAVE;\n', '    } else if (max == dapr) {\n', '      newProvider = Lender.DYDX;\n', '    }\n', '    return newProvider;\n', '  }\n', '\n', '  function getAave() public view returns (address) {\n', '    return LendingPoolAddressesProvider(aave).getLendingPool();\n', '  }\n', '  function getAaveCore() public view returns (address) {\n', '    return LendingPoolAddressesProvider(aave).getLendingPoolCore();\n', '  }\n', '\n', '  function approveToken() public {\n', '      IERC20(token).safeApprove(compound, uint(-1));\n', '      IERC20(token).safeApprove(dydx, uint(-1));\n', '      IERC20(token).safeApprove(getAaveCore(), uint(-1));\n', '      IERC20(token).safeApprove(fulcrum, uint(-1));\n', '  }\n', '\n', '  function balance() public view returns (uint256) {\n', '    return IERC20(token).balanceOf(address(this));\n', '  }\n', '  function balanceDydxAvailable() public view returns (uint256) {\n', '      return IERC20(token).balanceOf(dydx);\n', '  }\n', '  function balanceDydx() public view returns (uint256) {\n', '      Wei memory bal = DyDx(dydx).getAccountWei(Info(address(this), 0), dToken);\n', '      return bal.value;\n', '  }\n', '  function balanceCompound() public view returns (uint256) {\n', '      return IERC20(compound).balanceOf(address(this));\n', '  }\n', '  function balanceCompoundInToken() public view returns (uint256) {\n', '    // Mantisa 1e18 to decimals\n', '    uint256 b = balanceCompound();\n', '    if (b > 0) {\n', '      b = b.mul(Compound(compound).exchangeRateStored()).div(1e18);\n', '    }\n', '    return b;\n', '  }\n', '  function balanceFulcrumAvailable() public view returns (uint256) {\n', '      return IERC20(chai).balanceOf(fulcrum);\n', '  }\n', '  function balanceFulcrumInToken() public view returns (uint256) {\n', '    uint256 b = balanceFulcrum();\n', '    if (b > 0) {\n', '      b = Fulcrum(fulcrum).assetBalanceOf(address(this));\n', '    }\n', '    return b;\n', '  }\n', '  function balanceFulcrum() public view returns (uint256) {\n', '    return IERC20(fulcrum).balanceOf(address(this));\n', '  }\n', '  function balanceAaveAvailable() public view returns (uint256) {\n', '      return IERC20(token).balanceOf(aavePool);\n', '  }\n', '  function balanceAave() public view returns (uint256) {\n', '    return IERC20(aaveToken).balanceOf(address(this));\n', '  }\n', '\n', '  function rebalance() public {\n', '    Lender newProvider = recommend();\n', '\n', '    if (newProvider != provider) {\n', '      _withdrawAll();\n', '    }\n', '\n', '    if (balance() > 0) {\n', '      if (newProvider == Lender.DYDX) {\n', '        _supplyDydx(balance());\n', '      } else if (newProvider == Lender.FULCRUM) {\n', '        _supplyFulcrum(balance());\n', '      } else if (newProvider == Lender.COMPOUND) {\n', '        _supplyCompound(balance());\n', '      } else if (newProvider == Lender.AAVE) {\n', '        _supplyAave(balance());\n', '      }\n', '    }\n', '\n', '    provider = newProvider;\n', '  }\n', '\n', '  function _withdrawAll() internal {\n', '    uint256 amount = balanceCompound();\n', '    if (amount > 0) {\n', '      _withdrawSomeCompound(balanceCompoundInToken().sub(1));\n', '    }\n', '    amount = balanceDydx();\n', '    if (amount > 0) {\n', '      if (amount > balanceDydxAvailable()) {\n', '        amount = balanceDydxAvailable();\n', '      }\n', '      _withdrawDydx(amount);\n', '    }\n', '    amount = balanceFulcrum();\n', '    if (amount > 0) {\n', '      if (amount > balanceFulcrumAvailable().sub(1)) {\n', '        amount = balanceFulcrumAvailable().sub(1);\n', '      }\n', '      _withdrawSomeFulcrum(amount);\n', '    }\n', '    amount = balanceAave();\n', '    if (amount > 0) {\n', '      if (amount > balanceAaveAvailable()) {\n', '        amount = balanceAaveAvailable();\n', '      }\n', '      _withdrawAave(amount);\n', '    }\n', '  }\n', '\n', '  function _withdrawSomeCompound(uint256 _amount) internal {\n', '    uint256 b = balanceCompound();\n', '    uint256 bT = balanceCompoundInToken();\n', '    require(bT >= _amount, "insufficient funds");\n', '    // can have unintentional rounding errors\n', '    uint256 amount = (b.mul(_amount)).div(bT).add(1);\n', '    _withdrawCompound(amount);\n', '  }\n', '\n', '  function _withdrawSomeFulcrum(uint256 _amount) internal {\n', '    uint256 b = balanceFulcrum();\n', '    uint256 bT = balanceFulcrumInToken();\n', '    require(bT >= _amount, "insufficient funds");\n', '    // can have unintentional rounding errors\n', '    uint256 amount = (b.mul(_amount)).div(bT).add(1);\n', '    _withdrawFulcrum(amount);\n', '  }\n', '\n', '\n', '  function _withdrawSome(uint256 _amount) internal returns (bool) {\n', '    uint256 origAmount = _amount;\n', '\n', '    uint256 amount = balanceCompound();\n', '    if (amount > 0) {\n', '      if (_amount > balanceCompoundInToken().sub(1)) {\n', '        _withdrawSomeCompound(balanceCompoundInToken().sub(1));\n', '        _amount = origAmount.sub(IERC20(token).balanceOf(address(this)));\n', '      } else {\n', '        _withdrawSomeCompound(_amount);\n', '        return true;\n', '      }\n', '    }\n', '\n', '    amount = balanceDydx();\n', '    if (amount > 0) {\n', '      if (_amount > balanceDydxAvailable()) {\n', '        _withdrawDydx(balanceDydxAvailable());\n', '        _amount = origAmount.sub(IERC20(token).balanceOf(address(this)));\n', '      } else {\n', '        _withdrawDydx(_amount);\n', '        return true;\n', '      }\n', '    }\n', '\n', '    amount = balanceFulcrum();\n', '    if (amount > 0) {\n', '      if (_amount > balanceFulcrumAvailable().sub(1)) {\n', '        amount = balanceFulcrumAvailable().sub(1);\n', '        _withdrawSomeFulcrum(balanceFulcrumAvailable().sub(1));\n', '        _amount = origAmount.sub(IERC20(token).balanceOf(address(this)));\n', '      } else {\n', '        _withdrawSomeFulcrum(amount);\n', '        return true;\n', '      }\n', '    }\n', '\n', '    amount = balanceAave();\n', '    if (amount > 0) {\n', '      if (_amount > balanceAaveAvailable()) {\n', '        _withdrawAave(balanceAaveAvailable());\n', '        _amount = origAmount.sub(IERC20(token).balanceOf(address(this)));\n', '      } else {\n', '        _withdrawAave(_amount);\n', '        return true;\n', '      }\n', '    }\n', '\n', '    return true;\n', '  }\n', '\n', '  function _supplyDydx(uint256 amount) internal {\n', '      Info[] memory infos = new Info[](1);\n', '      infos[0] = Info(address(this), 0);\n', '\n', '      AssetAmount memory amt = AssetAmount(true, AssetDenomination.Wei, AssetReference.Delta, amount);\n', '      ActionArgs memory act;\n', '      act.actionType = ActionType.Deposit;\n', '      act.accountId = 0;\n', '      act.amount = amt;\n', '      act.primaryMarketId = dToken;\n', '      act.otherAddress = address(this);\n', '\n', '      ActionArgs[] memory args = new ActionArgs[](1);\n', '      args[0] = act;\n', '\n', '      DyDx(dydx).operate(infos, args);\n', '  }\n', '\n', '  function _supplyAave(uint amount) internal {\n', '      Aave(getAave()).deposit(token, amount, 0);\n', '  }\n', '  function _supplyFulcrum(uint amount) internal {\n', '      require(Fulcrum(fulcrum).mint(address(this), amount) > 0, "FULCRUM: supply failed");\n', '  }\n', '  function _supplyCompound(uint amount) internal {\n', '      require(Compound(compound).mint(amount) == 0, "COMPOUND: supply failed");\n', '  }\n', '  function _withdrawAave(uint amount) internal {\n', '      AToken(aaveToken).redeem(amount);\n', '  }\n', '  function _withdrawFulcrum(uint amount) internal {\n', '      require(Fulcrum(fulcrum).burn(address(this), amount) > 0, "FULCRUM: withdraw failed");\n', '  }\n', '  function _withdrawCompound(uint amount) internal {\n', '      require(Compound(compound).redeem(amount) == 0, "COMPOUND: withdraw failed");\n', '  }\n', '\n', '  function _withdrawDydx(uint256 amount) internal {\n', '      Info[] memory infos = new Info[](1);\n', '      infos[0] = Info(address(this), 0);\n', '\n', '      AssetAmount memory amt = AssetAmount(false, AssetDenomination.Wei, AssetReference.Delta, amount);\n', '      ActionArgs memory act;\n', '      act.actionType = ActionType.Withdraw;\n', '      act.accountId = 0;\n', '      act.amount = amt;\n', '      act.primaryMarketId = dToken;\n', '      act.otherAddress = address(this);\n', '\n', '      ActionArgs[] memory args = new ActionArgs[](1);\n', '      args[0] = act;\n', '\n', '      DyDx(dydx).operate(infos, args);\n', '  }\n', '\n', '  function calcPoolValueInToken() public view returns (uint) {\n', '    return balanceCompoundInToken()\n', '      .add(balanceFulcrumInToken())\n', '      .add(balanceDydx())\n', '      .add(balanceAave())\n', '      .add(balance());\n', '  }\n', '\n', '  function getPricePerFullShare() public view returns (uint) {\n', '    uint _pool = calcPoolValueInToken();\n', '    return _pool.mul(1e18).div(_totalSupply);\n', '  }\n', '}']