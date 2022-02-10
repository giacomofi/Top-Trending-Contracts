['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-18\n', '*/\n', '\n', '// File: contracts/utils/Ownable.sol\n', '\n', 'pragma solidity >=0.4.21 <0.6.0;\n', '\n', 'contract Ownable {\n', '    address private _contract_owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = msg.sender;\n', '        _contract_owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _contract_owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_contract_owner == msg.sender, "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_contract_owner, newOwner);\n', '        _contract_owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/utils/SafeMath.sol\n', '\n', 'pragma solidity >=0.4.21 <0.6.0;\n', '\n', 'library SafeMath {\n', '    function safeAdd(uint a, uint b) public pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a, "add");\n', '    }\n', '    function safeSubR(uint a, uint b, string memory s) public pure returns (uint c) {\n', '        require(b <= a, s);\n', '        c = a - b;\n', '    }\n', '    function safeSub(uint a, uint b) public pure returns (uint c) {\n', '        require(b <= a, "sub");\n', '        c = a - b;\n', '    }\n', '    function safeMul(uint a, uint b) public pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b, "mul");\n', '    }\n', '    function safeDiv(uint a, uint b) public pure returns (uint c) {\n', '        require(b > 0, "div");\n', '        c = a / b;\n', '    }\n', '    function safeDivR(uint a, uint b, string memory s) public pure returns (uint c) {\n', '        require(b > 0, s);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '// File: contracts/utils/Address.sol\n', '\n', 'pragma solidity >=0.4.21 <0.6.0;\n', '\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != 0x0 && codehash != accountHash);\n', '    }\n', '    function toPayable(address account) internal pure returns (address payable) {\n', '        return address(uint160(account));\n', '    }\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-call-value\n', '        (bool success, ) = recipient.call.value(amount)("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '}\n', '\n', '// File: contracts/erc20/IERC20.sol\n', '\n', 'pragma solidity >=0.4.21 <0.6.0;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: contracts/erc20/SafeERC20.sol\n', '\n', 'pragma solidity >=0.4.21 <0.6.0;\n', '\n', '\n', '\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).safeAdd(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).safeSub(value);\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/erc20/ERC20DepositApprover.sol\n', '\n', 'pragma solidity >=0.4.21 <0.6.0;\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract TargetInterface{\n', '  function deposit(uint256 _amount) public;\n', '}\n', '\n', 'contract ERC20DepositApprover{\n', '  using SafeERC20 for IERC20;\n', '  using SafeMath for uint256;\n', '\n', '  function allowance(address token, address owner, address spender) public view returns(uint256){\n', '    return IERC20(token).allowance(owner, spender);\n', '  }\n', '\n', '  event ApproverDeposit(address from, address token, uint256 amount, address target, address target_lp_token, uint256 target_lp_amount);\n', '  function deposit(address _token, uint256 _amount, address _target, address _target_lp_token) public{\n', '    require(_token != address(0x0), "invalid token");\n', '    require(_target != address(0x0), "invalid target");\n', '    require(IERC20(_token).allowance(msg.sender, address(this)) >= _amount, "ERC20DepositApprover: not enough allowance");\n', '    require(IERC20(_token).balanceOf(msg.sender) >= _amount, "ERC20DepositApprover: not enough balance");\n', '\n', '    IERC20(_token).safeTransferFrom(msg.sender, address(this), _amount);\n', '\n', '    if(IERC20(_token).allowance(address(this), _target) != 0){\n', '      IERC20(_token).safeApprove(_target, 0);\n', '    }\n', '    IERC20(_token).safeApprove(_target, _amount);\n', '\n', '    uint256 prev = 0;\n', '    if(_target_lp_token != address(0x0)){\n', '      prev = IERC20(_target_lp_token).balanceOf(address(this));\n', '    }\n', '    TargetInterface(_target).deposit(_amount);\n', '\n', '    uint256 _after = 0;\n', '    uint256 delta = 0;\n', '    if(_target_lp_token != address(0x0)){\n', '      _after = IERC20(_target_lp_token).balanceOf(address(this));\n', '      delta = _after.safeSub(prev);\n', '      if(delta > 0){\n', '        IERC20(_target_lp_token).safeTransfer(msg.sender, delta);\n', '      }\n', '    }\n', '    emit ApproverDeposit(msg.sender, _token, _amount, _target, _target_lp_token, delta);\n', '  }\n', '\n', '}']