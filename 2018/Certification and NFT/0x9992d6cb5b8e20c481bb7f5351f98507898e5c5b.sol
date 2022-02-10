['pragma solidity 0.4.20;\n', '\n', '// No deps verison.\n', '\n', '/**\n', ' * @title ERC20\n', ' * @dev A standard interface for tokens.\n', ' * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', ' */\n', 'contract ERC20 {\n', '  \n', '    /// @dev Returns the total token supply\n', '    function totalSupply() public constant returns (uint256 supply);\n', '\n', '    /// @dev Returns the account balance of the account with address _owner\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '\n', '    /// @dev Transfers _value number of tokens to address _to\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @dev Transfers _value number of tokens from address _from to address _to\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @dev Allows _spender to withdraw from the msg.sender&#39;s account up to the _value amount\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    /// @dev Returns the amount which _spender is still allowed to withdraw from _owner\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '}\n', '\n', '/// @title Owned\n', '/// @author Adri&#224; Massanet <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="d1b0b5a3b8b091b2beb5b4b2bebfa5b4a9a5ffb8be">[email&#160;protected]</a>>\n', '/// @notice The Owned contract has an owner address, and provides basic \n', '///  authorization control functions, this simplifies & the implementation of\n', '///  user permissions; this contract has three work flows for a change in\n', '///  ownership, the first requires the new owner to validate that they have the\n', '///  ability to accept ownership, the second allows the ownership to be\n', '///  directly transfered without requiring acceptance, and the third allows for\n', '///  the ownership to be removed to allow for decentralization \n', 'contract Owned {\n', '\n', '    address public owner;\n', '    address public newOwnerCandidate;\n', '\n', '    event OwnershipRequested(address indexed by, address indexed to);\n', '    event OwnershipTransferred(address indexed from, address indexed to);\n', '    event OwnershipRemoved();\n', '\n', '    /// @dev The constructor sets the `msg.sender` as the`owner` of the contract\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /// @dev `owner` is the only address that can call a function with this\n', '    /// modifier\n', '    modifier onlyOwner() {\n', '        require (msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    /// @dev In this 1st option for ownership transfer `proposeOwnership()` must\n', '    ///  be called first by the current `owner` then `acceptOwnership()` must be\n', '    ///  called by the `newOwnerCandidate`\n', '    /// @notice `onlyOwner` Proposes to transfer control of the contract to a\n', '    ///  new owner\n', '    /// @param _newOwnerCandidate The address being proposed as the new owner\n', '    function proposeOwnership(address _newOwnerCandidate) public onlyOwner {\n', '        newOwnerCandidate = _newOwnerCandidate;\n', '        OwnershipRequested(msg.sender, newOwnerCandidate);\n', '    }\n', '\n', '    /// @notice Can only be called by the `newOwnerCandidate`, accepts the\n', '    ///  transfer of ownership\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwnerCandidate);\n', '\n', '        address oldOwner = owner;\n', '        owner = newOwnerCandidate;\n', '        newOwnerCandidate = 0x0;\n', '\n', '        OwnershipTransferred(oldOwner, owner);\n', '    }\n', '\n', '    /// @dev In this 2nd option for ownership transfer `changeOwnership()` can\n', '    ///  be called and it will immediately assign ownership to the `newOwner`\n', '    /// @notice `owner` can step down and assign some other address to this role\n', '    /// @param _newOwner The address of the new owner\n', '    function changeOwnership(address _newOwner) public onlyOwner {\n', '        require(_newOwner != 0x0);\n', '\n', '        address oldOwner = owner;\n', '        owner = _newOwner;\n', '        newOwnerCandidate = 0x0;\n', '\n', '        OwnershipTransferred(oldOwner, owner);\n', '    }\n', '\n', '    /// @dev In this 3rd option for ownership transfer `removeOwnership()` can\n', '    ///  be called and it will immediately assign ownership to the 0x0 address;\n', '    ///  it requires a 0xdece be input as a parameter to prevent accidental use\n', '    /// @notice Decentralizes the contract, this operation cannot be undone \n', '    /// @param _dac `0xdac` has to be entered for this function to work\n', '    function removeOwnership(address _dac) public onlyOwner {\n', '        require(_dac == 0xdac);\n', '        owner = 0x0;\n', '        newOwnerCandidate = 0x0;\n', '        OwnershipRemoved();     \n', '    }\n', '} \n', '\n', '/// @dev `Escapable` is a base level contract built off of the `Owned`\n', '///  contract; it creates an escape hatch function that can be called in an\n', '///  emergency that will allow designated addresses to send any ether or tokens\n', '///  held in the contract to an `escapeHatchDestination` as long as they were\n', '///  not blacklisted\n', 'contract Escapable is Owned {\n', '    address public escapeHatchCaller;\n', '    address public escapeHatchDestination;\n', '    mapping (address=>bool) private escapeBlacklist; // Token contract addresses\n', '\n', '    /// @notice The Constructor assigns the `escapeHatchDestination` and the\n', '    ///  `escapeHatchCaller`\n', '    /// @param _escapeHatchCaller The address of a trusted account or contract\n', '    ///  to call `escapeHatch()` to send the ether in this contract to the\n', '    ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller`\n', '    ///  cannot move funds out of `escapeHatchDestination`\n', '    /// @param _escapeHatchDestination The address of a safe location (usu a\n', '    ///  Multisig) to send the ether held in this contract; if a neutral address\n', '    ///  is required, the WHG Multisig is an option:\n', '    ///  0x8Ff920020c8AD673661c8117f2855C384758C572 \n', '    function Escapable(address _escapeHatchCaller, address _escapeHatchDestination) public {\n', '        escapeHatchCaller = _escapeHatchCaller;\n', '        escapeHatchDestination = _escapeHatchDestination;\n', '    }\n', '\n', '    /// @dev The addresses preassigned as `escapeHatchCaller` or `owner`\n', '    ///  are the only addresses that can call a function with this modifier\n', '    modifier onlyEscapeHatchCallerOrOwner {\n', '        require ((msg.sender == escapeHatchCaller)||(msg.sender == owner));\n', '        _;\n', '    }\n', '\n', '    /// @notice Creates the blacklist of tokens that are not able to be taken\n', '    ///  out of the contract; can only be done at the deployment, and the logic\n', '    ///  to add to the blacklist will be in the constructor of a child contract\n', '    /// @param _token the token contract address that is to be blacklisted \n', '    function blacklistEscapeToken(address _token) internal {\n', '        escapeBlacklist[_token] = true;\n', '        EscapeHatchBlackistedToken(_token);\n', '    }\n', '\n', '    /// @notice Checks to see if `_token` is in the blacklist of tokens\n', '    /// @param _token the token address being queried\n', '    /// @return False if `_token` is in the blacklist and can&#39;t be taken out of\n', '    ///  the contract via the `escapeHatch()`\n', '    function isTokenEscapable(address _token) view public returns (bool) {\n', '        return !escapeBlacklist[_token];\n', '    }\n', '\n', '    /// @notice The `escapeHatch()` should only be called as a last resort if a\n', '    /// security issue is uncovered or something unexpected happened\n', '    /// @param _token to transfer, use 0x0 for ether\n', '    function escapeHatch(address _token) public onlyEscapeHatchCallerOrOwner {   \n', '        require(escapeBlacklist[_token]==false);\n', '\n', '        uint256 balance;\n', '\n', '        /// @dev Logic for ether\n', '        if (_token == 0x0) {\n', '            balance = this.balance;\n', '            escapeHatchDestination.transfer(balance);\n', '            EscapeHatchCalled(_token, balance);\n', '            return;\n', '        }\n', '        /// @dev Logic for tokens\n', '        ERC20 token = ERC20(_token);\n', '        balance = token.balanceOf(this);\n', '        require(token.transfer(escapeHatchDestination, balance));\n', '        EscapeHatchCalled(_token, balance);\n', '    }\n', '\n', '    /// @notice Changes the address assigned to call `escapeHatch()`\n', '    /// @param _newEscapeHatchCaller The address of a trusted account or\n', '    ///  contract to call `escapeHatch()` to send the value in this contract to\n', '    ///  the `escapeHatchDestination`; it would be ideal that `escapeHatchCaller`\n', '    ///  cannot move funds out of `escapeHatchDestination`\n', '    function changeHatchEscapeCaller(address _newEscapeHatchCaller) public onlyEscapeHatchCallerOrOwner {\n', '        escapeHatchCaller = _newEscapeHatchCaller;\n', '    }\n', '\n', '    event EscapeHatchBlackistedToken(address token);\n', '    event EscapeHatchCalled(address token, uint amount);\n', '}\n', '\n', 'contract InternalTester is Escapable(0x1Ff21eCa1c3ba96ed53783aB9C92FfbF77862584, 0x1Ff21eCa1c3ba96ed53783aB9C92FfbF77862584) {\n', '    function sendETH(address _to) payable public returns(bool) {\n', '        _safeTransfer(_to, msg.value);\n', '        return true;\n', '    }\n', '    \n', '    function callETH(address _to) payable public returns(bool) {\n', '        _safeCall(_to, msg.value);\n', '        return true;\n', '    }\n', '    \n', '    function sendERC20(ERC20 _token, address _to, uint _amount) public returns(bool) {\n', '        _safeERC20Transfer(_token, _to, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function _safeTransfer(address _to, uint _amount) internal {\n', '        require(_to != 0);\n', '        _to.transfer(_amount);\n', '    }\n', '\n', '    function _safeCall(address _to, uint _amount) internal {\n', '        require(_to != 0);\n', '        require(_to.call.value(_amount)());\n', '    }\n', '\n', '    function _safeERC20Transfer(ERC20 _token, address _to, uint _amount) internal {\n', '        require(_to != 0);\n', '        require(_token.transferFrom(msg.sender, _to, _amount));\n', '    }\n', '}']