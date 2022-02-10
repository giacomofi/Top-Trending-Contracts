['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-19\n', '*/\n', '\n', '// File: contracts/erc20/IERC20.sol\n', '\n', 'pragma solidity >=0.4.21 <0.6.0;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: contracts/utils/Ownable.sol\n', '\n', 'pragma solidity >=0.4.21 <0.6.0;\n', '\n', 'contract Ownable {\n', '    address private _contract_owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = msg.sender;\n', '        _contract_owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _contract_owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_contract_owner == msg.sender, "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_contract_owner, newOwner);\n', '        _contract_owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/core/IPool.sol\n', '\n', 'pragma solidity >=0.4.21 <0.6.0;\n', '\n', 'contract ICurvePool{\n', '  function deposit(uint256 _amount) public;\n', '  function withdraw(uint256 _amount) public;\n', '\n', '  function get_virtual_price() public view returns(uint256);\n', '\n', '  function get_lp_token_balance() public view returns(uint256);\n', '\n', '  function get_lp_token_addr() public view returns(address);\n', '\n', '  function earn_crv() public;\n', '\n', '  string public name;\n', '}\n', '\n', 'contract ICurvePoolForETH{\n', '  function deposit() public payable;\n', '  function withdraw(uint256 _amount) public;\n', '\n', '  function get_virtual_price() public view returns(uint256);\n', '\n', '  function get_lp_token_balance() public view returns(uint256);\n', '\n', '  function get_lp_token_addr() public view returns(address);\n', '\n', '  function earn_crv() public;\n', '\n', '  string public name;\n', '}\n', '\n', '// File: contracts/utils/TokenClaimer.sol\n', '\n', 'pragma solidity >=0.4.21 <0.6.0;\n', '\n', '\n', '\n', 'contract TokenClaimer{\n', '\n', '    event ClaimedTokens(address indexed _token, address indexed _to, uint _amount);\n', '    /// @notice This method can be used by the controller to extract mistakenly\n', '    ///  sent tokens to this contract.\n', '    /// @param _token The address of the token contract that you want to recover\n', '    ///  set to 0 in case you want to extract ether.\n', '  function _claimStdTokens(address _token, address payable to) internal {\n', '        if (_token == address(0x0)) {\n', '            to.transfer(address(this).balance);\n', '            return;\n', '        }\n', '        IERC20 token = IERC20(_token);\n', '        uint balance = token.balanceOf(address(this));\n', '\n', '        (bool status,) = _token.call(abi.encodeWithSignature("transfer(address,uint256)", to, balance));\n', '        require(status, "call failed");\n', '        emit ClaimedTokens(_token, to, balance);\n', '  }\n', '}\n', '\n', '// File: contracts/core/ethpool/IethPoolBase.sol\n', '\n', 'pragma solidity >=0.4.21 <0.6.0;\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract PriceInterfaceEth{\n', '  function get_virtual_price() public view returns(uint256);\n', '}\n', '\n', 'contract CRVGaugeInterfaceEth{\n', '  function deposit(uint256 _value) public;\n', '  function withdraw(uint256 _value) public;\n', '  function claim_rewards(address _address) public;\n', '}\n', '\n', 'contract MinterInterfaceEth{\n', '  function mint(address gauge_addr) public;\n', '}\n', '\n', 'contract IethPoolBase is ICurvePoolForETH, TokenClaimer, Ownable{\n', '  address public crv_token_addr;\n', '  address public controller;\n', '  address public vault;\n', '  address public lp_token_addr;\n', '  address public extra_token_addr;\n', '\n', '  CRVGaugeInterfaceEth public crv_gauge_addr;\n', '  MinterInterfaceEth public crv_minter_addr;\n', '\n', '  uint256 public lp_balance;\n', '  uint256 public deposit_eth_amount;\n', '  uint256 public withdraw_eth_amount;\n', '\n', '  modifier onlyController(){\n', '    require((controller == msg.sender)||(vault == msg.sender), "only controller can call this");\n', '    _;\n', '  }\n', '\n', '  constructor() public{\n', '    crv_token_addr = address(0xD533a949740bb3306d119CC777fa900bA034cd52);\n', '    crv_minter_addr = MinterInterfaceEth(0xd061D61a4d941c39E5453435B6345Dc261C2fcE0);\n', '  }\n', '\n', '  function deposit_eth() internal;\n', '\n', '  //@_amount: USDC amount\n', '  function deposit() public payable onlyController{\n', '    uint _amount = msg.value;\n', '    deposit_eth_amount = deposit_eth_amount + _amount;\n', '    deposit_eth();\n', '    uint256 cur = IERC20(lp_token_addr).balanceOf(address(this));\n', '    lp_balance = lp_balance + cur;\n', '    deposit_to_gauge();\n', '  }\n', '\n', '  //deposit all lp token to gauage to mine CRV\n', '  function deposit_to_gauge() internal {\n', '    IERC20(lp_token_addr).approve(address(crv_gauge_addr), 0);\n', '    uint256 cur = IERC20(lp_token_addr).balanceOf(address(this));\n', '    IERC20(lp_token_addr).approve(address(crv_gauge_addr), cur);\n', '    crv_gauge_addr.deposit(cur);\n', '    require(IERC20(lp_token_addr).balanceOf(address(this)) == 0, "deposit_to_gauge: unexpected exchanges");\n', '  }\n', '\n', '  function withdraw_from_curve(uint256 _amount) internal;\n', '\n', '  //@_amount: lp token amount\n', '  function withdraw(uint256 _amount) public onlyController{\n', '      withdraw_from_gauge(_amount);\n', '      require(IERC20(lp_token_addr).balanceOf(address(this)) == _amount, "gauge: amount mismatch");\n', '      withdraw_from_curve(_amount);\n', '      lp_balance = lp_balance - _amount;\n', '      msg.sender.transfer(address(this).balance);\n', '  }\n', '\n', '  function withdraw_from_gauge(uint256 _amount) internal{\n', '    require(_amount <= lp_balance, "withdraw_from_gauge: insufficient amount");\n', '    crv_gauge_addr.withdraw(_amount);\n', '  }\n', '\n', '  function setController(address _controller, address _vault) public onlyOwner{\n', '    controller = _controller;\n', '    vault = _vault;\n', '  }\n', '\n', '  function claimStdToken(address _token, address payable to) public onlyOwner{\n', '    _claimStdTokens(_token, to);\n', '  }\n', '\n', '  function earn_crv() public onlyController{\n', '    require(crv_minter_addr != MinterInterfaceEth(0x0), "no crv minter");\n', '    crv_minter_addr.mint(address(crv_gauge_addr));\n', '    IERC20(crv_token_addr).transfer(msg.sender, IERC20(crv_token_addr).balanceOf(address(this)));\n', '    if (extra_token_addr != address(0x0)) {\n', '      crv_gauge_addr.claim_rewards(address(this));\n', '      IERC20(extra_token_addr).transfer(msg.sender, IERC20(extra_token_addr).balanceOf(address(this)));\n', '    }\n', '  }\n', '\n', '  function get_lp_token_balance() public view returns(uint256){\n', '    return lp_balance;\n', '  }\n', '\n', '  function get_lp_token_addr() public view returns(address){\n', '    return lp_token_addr;\n', '  }\n', '\n', '  function() external payable{\n', '\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/utils/SafeMath.sol\n', '\n', 'pragma solidity >=0.4.21 <0.6.0;\n', '\n', 'library SafeMath {\n', '    function safeAdd(uint a, uint b) public pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a, "add");\n', '    }\n', '    function safeSubR(uint a, uint b, string memory s) public pure returns (uint c) {\n', '        require(b <= a, s);\n', '        c = a - b;\n', '    }\n', '    function safeSub(uint a, uint b) public pure returns (uint c) {\n', '        require(b <= a, "sub");\n', '        c = a - b;\n', '    }\n', '    function safeMul(uint a, uint b) public pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b, "mul");\n', '    }\n', '    function safeDiv(uint a, uint b) public pure returns (uint c) {\n', '        require(b > 0, "div");\n', '        c = a / b;\n', '    }\n', '    function safeDivR(uint a, uint b, string memory s) public pure returns (uint c) {\n', '        require(b > 0, s);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '// File: contracts/utils/Address.sol\n', '\n', 'pragma solidity >=0.4.21 <0.6.0;\n', '\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != 0x0 && codehash != accountHash);\n', '    }\n', '    function toPayable(address account) internal pure returns (address payable) {\n', '        return address(uint160(account));\n', '    }\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-call-value\n', '        (bool success, ) = recipient.call.value(amount)("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '}\n', '\n', '// File: contracts/erc20/SafeERC20.sol\n', '\n', 'pragma solidity >=0.4.21 <0.6.0;\n', '\n', '\n', '\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).safeAdd(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).safeSub(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/core/ethpool/SethPool.sol\n', '\n', 'pragma solidity >=0.4.21 <0.6.0;\n', '\n', '\n', '\n', '\n', 'contract CurveInterfaceSeth{\n', '  function add_liquidity(uint256[2] memory amounts, uint256 min_mint_amount) public payable returns(uint256);\n', '  function remove_liquidity_one_coin(uint256 _token_amount, int128 i, uint256 min_mint_amount) public returns(uint256);\n', '}\n', '\n', 'contract SethPool is IethPoolBase{\n', '  using SafeERC20 for IERC20;\n', '\n', '  CurveInterfaceSeth public pool_deposit;\n', '\n', '  constructor() public{\n', '    name = "Seth";\n', '    lp_token_addr = address(0xA3D87FffcE63B53E0d54fAa1cc983B7eB0b74A9c);\n', '    crv_gauge_addr = CRVGaugeInterfaceEth(0x3C0FFFF15EA30C35d7A85B85c0782D6c94e1d238);\n', '    pool_deposit = CurveInterfaceSeth(0xc5424B857f758E906013F3555Dad202e4bdB4567);\n', '  }\n', '\n', '  function deposit_eth() internal {\n', '    uint _amount = msg.value;\n', '    uint256[2] memory uamounts = [_amount, 0];\n', '    pool_deposit.add_liquidity.value(_amount)(uamounts, 0);\n', '  }\n', '\n', '\n', '  function withdraw_from_curve(uint256 _amount) internal{\n', '    require(_amount <= get_lp_token_balance(), "withdraw_from_curve: too large amount");\n', '    require(address(pool_deposit).balance > 0, "money is 0");\n', '    pool_deposit.remove_liquidity_one_coin(_amount, 0, 0);\n', '\n', '  }\n', '\n', '  function get_virtual_price() public view returns(uint256){\n', '    return PriceInterfaceEth(address(pool_deposit)).get_virtual_price();\n', '  }\n', '}']