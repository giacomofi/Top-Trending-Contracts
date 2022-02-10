['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-17\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.6.0;\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(ERC20 token, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    /**\n', '     * @dev Deprecated. This function has issues similar to the ones found in\n', '     * {IERC20-approve}, and its usage is discouraged.\n', '     */\n', '    function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, 0));\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(ERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(ERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function _callOptionalReturn(ERC20 token, bytes memory data) private {\n', '\n', '        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', 'interface ERC20 {\n', '    function totalSupply() external view returns (uint256 supply);\n', '\n', '    function balanceOf(address _owner) external view returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) external returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '        external\n', '        returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) external returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) external view returns (uint256 remaining);\n', '\n', '    function decimals() external view returns (uint256 digits);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'abstract contract DSProxyInterface {\n', '\n', "    /// Truffle wont compile if this isn't commented\n", '    // function execute(bytes memory _code, bytes memory _data)\n', '    //     public virtual\n', '    //     payable\n', '    //     returns (address, bytes32);\n', '\n', '    function execute(address _target, bytes memory _data) public virtual payable returns (bytes32);\n', '\n', '    function setCache(address _cacheAddr) public virtual payable returns (bool);\n', '\n', '    function owner() public virtual returns (address);\n', '}\n', '\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return _functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        return _functionCallWithValue(target, data, value, errorMessage);\n', '    }\n', '\n', '    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', 'contract AdminAuth {\n', '\n', '    using SafeERC20 for ERC20;\n', '\n', '    address public owner;\n', '    address public admin;\n', '\n', '    modifier onlyOwner() {\n', '        require(owner == msg.sender);\n', '        _;\n', '    }\n', '\n', '    modifier onlyAdmin() {\n', '        require(admin == msg.sender);\n', '        _;\n', '    }\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        admin = 0xac04A6f65491Df9634f6c5d640Bcc7EfFdbea326;\n', '    }\n', '\n', '    /// @notice Admin is set by owner first time, after that admin is super role and has permission to change owner\n', '    /// @param _admin Address of multisig that becomes admin\n', '    function setAdminByOwner(address _admin) public {\n', '        require(msg.sender == owner);\n', '        require(admin == address(0));\n', '\n', '        admin = _admin;\n', '    }\n', '\n', '    /// @notice Admin is able to set new admin\n', '    /// @param _admin Address of multisig that becomes new admin\n', '    function setAdminByAdmin(address _admin) public {\n', '        require(msg.sender == admin);\n', '\n', '        admin = _admin;\n', '    }\n', '\n', '    /// @notice Admin is able to change owner\n', '    /// @param _owner Address of new owner\n', '    function setOwnerByAdmin(address _owner) public {\n', '        require(msg.sender == admin);\n', '\n', '        owner = _owner;\n', '    }\n', '\n', '    /// @notice Destroy the contract\n', '    function kill() public onlyOwner {\n', '        selfdestruct(payable(owner));\n', '    }\n', '\n', '    /// @notice  withdraw stuck funds\n', '    function withdrawStuckFunds(address _token, uint _amount) public onlyOwner {\n', '        if (_token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {\n', '            payable(owner).transfer(_amount);\n', '        } else {\n', '            ERC20(_token).safeTransfer(owner, _amount);\n', '        }\n', '    }\n', '}\n', '\n', '/// @title Contract with the actuall DSProxy permission calls the automation operations\n', 'contract CompoundMonitorProxy is AdminAuth {\n', '\n', '    using SafeERC20 for ERC20;\n', '\n', '    uint public CHANGE_PERIOD;\n', '    address public monitor;\n', '    address public newMonitor;\n', '    address public lastMonitor;\n', '    uint public changeRequestedTimestamp;\n', '\n', '    mapping(address => bool) public allowed;\n', '\n', '    event MonitorChangeInitiated(address oldMonitor, address newMonitor);\n', '    event MonitorChangeCanceled();\n', '    event MonitorChangeFinished(address monitor);\n', '    event MonitorChangeReverted(address monitor);\n', '\n', "    // if someone who is allowed become malicious, owner can't be changed\n", '    modifier onlyAllowed() {\n', '        require(allowed[msg.sender] || msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier onlyMonitor() {\n', '        require (msg.sender == monitor);\n', '        _;\n', '    }\n', '\n', '    constructor(uint _changePeriod) public {\n', '        CHANGE_PERIOD = _changePeriod * 1 days;\n', '    }\n', '\n', '    /// @notice Only monitor contract is able to call execute on users proxy\n', '    /// @param _owner Address of cdp owner (users DSProxy address)\n', '    /// @param _compoundSaverProxy Address of CompoundSaverProxy\n', '    /// @param _data Data to send to CompoundSaverProxy\n', '    function callExecute(address _owner, address _compoundSaverProxy, bytes memory _data) public payable onlyMonitor {\n', '        // execute reverts if calling specific method fails\n', '        DSProxyInterface(_owner).execute{value: msg.value}(_compoundSaverProxy, _data);\n', '\n', '        // return if anything left\n', '        if (address(this).balance > 0) {\n', '            msg.sender.transfer(address(this).balance);\n', '        }\n', '    }\n', '\n', '    /// @notice Allowed users are able to set Monitor contract without any waiting period first time\n', '    /// @param _monitor Address of Monitor contract\n', '    function setMonitor(address _monitor) public onlyAllowed {\n', '        require(monitor == address(0));\n', '        monitor = _monitor;\n', '    }\n', '\n', '    /// @notice Allowed users are able to start procedure for changing monitor\n', '    /// @dev after CHANGE_PERIOD needs to call confirmNewMonitor to actually make a change\n', '    /// @param _newMonitor address of new monitor\n', '    function changeMonitor(address _newMonitor) public onlyAllowed {\n', '        require(changeRequestedTimestamp == 0);\n', '\n', '        changeRequestedTimestamp = now;\n', '        lastMonitor = monitor;\n', '        newMonitor = _newMonitor;\n', '\n', '        emit MonitorChangeInitiated(lastMonitor, newMonitor);\n', '    }\n', '\n', '    /// @notice At any point allowed users are able to cancel monitor change\n', '    function cancelMonitorChange() public onlyAllowed {\n', '        require(changeRequestedTimestamp > 0);\n', '\n', '        changeRequestedTimestamp = 0;\n', '        newMonitor = address(0);\n', '\n', '        emit MonitorChangeCanceled();\n', '    }\n', '\n', '    /// @notice Anyone is able to confirm new monitor after CHANGE_PERIOD if process is started\n', '    function confirmNewMonitor() public onlyAllowed {\n', '        require((changeRequestedTimestamp + CHANGE_PERIOD) < now);\n', '        require(changeRequestedTimestamp != 0);\n', '        require(newMonitor != address(0));\n', '\n', '        monitor = newMonitor;\n', '        newMonitor = address(0);\n', '        changeRequestedTimestamp = 0;\n', '\n', '        emit MonitorChangeFinished(monitor);\n', '    }\n', '\n', '    /// @notice Its possible to revert monitor to last used monitor\n', '    function revertMonitor() public onlyAllowed {\n', '        require(lastMonitor != address(0));\n', '\n', '        monitor = lastMonitor;\n', '\n', '        emit MonitorChangeReverted(monitor);\n', '    }\n', '\n', '\n', '    /// @notice Allowed users are able to add new allowed user\n', '    /// @param _user Address of user that will be allowed\n', '    function addAllowed(address _user) public onlyAllowed {\n', '        allowed[_user] = true;\n', '    }\n', '\n', '    /// @notice Allowed users are able to remove allowed user\n', '    /// @dev owner is always allowed even if someone tries to remove it from allowed mapping\n', '    /// @param _user Address of allowed user\n', '    function removeAllowed(address _user) public onlyAllowed {\n', '        allowed[_user] = false;\n', '    }\n', '\n', '    function setChangePeriod(uint _periodInDays) public onlyAllowed {\n', '        require(_periodInDays * 1 days > CHANGE_PERIOD);\n', '\n', '        CHANGE_PERIOD = _periodInDays * 1 days;\n', '    }\n', '\n', '    /// @notice In case something is left in contract, owner is able to withdraw it\n', '    /// @param _token address of token to withdraw balance\n', '    function withdrawToken(address _token) public onlyOwner {\n', '        uint balance = ERC20(_token).balanceOf(address(this));\n', '        ERC20(_token).safeTransfer(msg.sender, balance);\n', '    }\n', '\n', '    /// @notice In case something is left in contract, owner is able to withdraw it\n', '    function withdrawEth() public onlyOwner {\n', '        uint balance = address(this).balance;\n', '        msg.sender.transfer(balance);\n', '    }\n', '}']