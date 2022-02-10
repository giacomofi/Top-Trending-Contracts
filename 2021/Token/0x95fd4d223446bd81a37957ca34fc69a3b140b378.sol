['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-21\n', '*/\n', '\n', '// SPDX-License-Identifier: MPL-2.0\n', '\n', 'pragma solidity 0.6.6;\n', '\n', 'interface ITokenRecipient {\n', "  /// Typically called from a token contract's `approveAndCall` method, this\n", '  /// method will receive the original owner of the token (`_from`), the\n', '  /// transferred `_value` (in the case of an ERC721, the token id), the token\n', '  /// address (`_token`), and a blob of `_extraData` that is informally\n', '  /// specified by the implementor of this method as a way to communicate\n', '  /// additional parameters.\n', '  ///\n', '  /// Token calls to `receiveApproval` should revert if `receiveApproval`\n', '  /// reverts, and reverts should remove the approval.\n', '  ///\n', '  /// @param _from The original owner of the token approved for transfer.\n', '  /// @param _value For an ERC20, the amount approved for transfer; for an\n', '  ///        ERC721, the id of the token approved for transfer.\n', '  /// @param _token The address of the contract for the token whose transfer\n', '  ///        was approved.\n', '  /// @param _extraData An additional data blob forwarded unmodified through\n', '  ///        `approveAndCall`, used to allow the token owner to pass\n', '  ///         additional parameters and data to this method. The structure of\n', '  ///         the extra data is informally specified by the implementor of\n', '  ///         this interface.\n', '  function receiveApproval(\n', '    address _from,\n', '    uint256 _value,\n', '    address _token,\n', '    bytes calldata _extraData\n', '  ) external;\n', '}\n', '\n', 'library Roles {\n', '  struct Role {\n', '    mapping(address => bool) bearer;\n', '  }\n', '\n', '  /**\n', '   * @dev Give an account access to this role.\n', '   */\n', '  function add(Role storage role, address account) internal {\n', '    require(!has(role, account), "Roles: account already has role");\n', '    role.bearer[account] = true;\n', '  }\n', '\n', '  /**\n', "   * @dev Remove an account's access to this role.\n", '   */\n', '  function remove(Role storage role, address account) internal {\n', '    require(has(role, account), "Roles: account does not have role");\n', '    role.bearer[account] = false;\n', '  }\n', '\n', '  /**\n', '   * @dev Check if an account has this role.\n', '   * @return bool\n', '   */\n', '  function has(Role storage role, address account) internal view returns (bool) {\n', '    require(account != address(0), "Roles: account is the zero address");\n', '    return role.bearer[account];\n', '  }\n', '}\n', '\n', 'contract Initializable {\n', '\n', '  /**\n', '   * @dev Indicates that the contract has been initialized.\n', '   */\n', '  bool private initialized;\n', '\n', '  /**\n', '   * @dev Indicates that the contract is in the process of being initialized.\n', '   */\n', '  bool private initializing;\n', '\n', '  /**\n', '   * @dev Modifier to use in the initializer function of a contract.\n', '   */\n', '  modifier initializer() {\n', '    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");\n', '\n', '    bool isTopLevelCall = !initializing;\n', '    if (isTopLevelCall) {\n', '      initializing = true;\n', '      initialized = true;\n', '    }\n', '\n', '    _;\n', '\n', '    if (isTopLevelCall) {\n', '      initializing = false;\n', '    }\n', '  }\n', '\n', '  /// @dev Returns true if and only if the function is running in the constructor\n', '  function isConstructor() private view returns (bool) {\n', '    // extcodesize checks the size of the code stored in an address, and\n', '    // address returns the current address. Since the code is still not\n', '    // deployed when running a constructor, any checks on its code size will\n', '    // yield zero, making it an effective way to detect if a contract is\n', '    // under construction or not.\n', '    address self = address(this);\n', '    uint256 cs;\n', '    assembly { cs := extcodesize(self) }\n', '    return cs == 0;\n', '  }\n', '\n', '  // Reserved storage space to allow for layout changes in the future.\n', '  uint256[50] private ______gap;\n', '}\n', '\n', 'contract ContextUpgradeSafe is Initializable {\n', '    // Empty internal constructor, to prevent people from mistakenly deploying\n', '    // an instance of this contract, which should be used via inheritance.\n', '\n', '    function __Context_init() internal initializer {\n', '        __Context_init_unchained();\n', '    }\n', '\n', '    function __Context_init_unchained() internal initializer {\n', '\n', '\n', '    }\n', '\n', '\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '\n', '    uint256[50] private __gap;\n', '}\n', '\n', 'contract OwnableUpgradeSafe is Initializable, ContextUpgradeSafe {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '\n', '    function __Ownable_init() internal initializer {\n', '        __Context_init_unchained();\n', '        __Ownable_init_unchained();\n', '    }\n', '\n', '    function __Ownable_init_unchained() internal initializer {\n', '\n', '\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '\n', '    uint256[49] private __gap;\n', '}\n', '\n', '\n', '\n', 'contract MinterRole is ContextUpgradeSafe, OwnableUpgradeSafe {\n', '  using Roles for Roles.Role;\n', '\n', '  event MinterAdded(address indexed account);\n', '  event MinterRemoved(address indexed account);\n', '\n', '  Roles.Role private _minters;\n', '\n', '  modifier onlyMinter() {\n', '    require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");\n', '    _;\n', '  }\n', '\n', '  function isMinter(address account) public view returns (bool) {\n', '    return _minters.has(account);\n', '  }\n', '\n', '  function addMinter(address account) public onlyOwner {\n', '    _addMinter(account);\n', '  }\n', '\n', '  function renounceMinter() public {\n', '    _removeMinter(_msgSender());\n', '  }\n', '\n', '  function _addMinter(address account) internal {\n', '    _minters.add(account);\n', '    emit MinterAdded(account);\n', '  }\n', '\n', '  function _removeMinter(address account) internal {\n', '    _minters.remove(account);\n', '    emit MinterRemoved(account);\n', '  }\n', '}\n', '\n', 'interface IStrudel {\n', '\tfunction mint(address account, uint256 amount) external returns (bool);\n', '\n', '\tfunction burnFrom(address _account, uint256 _amount) external;\n', '\n', '\tfunction renounceMinter() external;\n', '}\n', '\n', '/// @title  Strudel Token.\n', '/// @notice This is the Strudel ERC20 contract.\n', 'contract StrudelWrapper is ITokenRecipient, MinterRole {\n', '\n', '\tevent LogSwapin(bytes32 indexed txhash, address indexed account, uint amount);\n', '\tevent LogSwapout(address indexed account, address indexed bindaddr, uint amount);\n', '\n', '\taddress public strdlAddr;\n', '\n', '\tconstructor(address _strdlAddr) public {\n', '\t\t__Ownable_init();\n', '\t\tstrdlAddr = _strdlAddr;\n', '\t}\n', '\n', '\tfunction mint(address to, uint256 amount) external onlyMinter returns (bool) {\n', '\t\tIStrudel(strdlAddr).mint(to, amount);\n', '\t\treturn true;\n', '\t}\n', '\n', '\tfunction burn(address from, uint256 amount) external onlyMinter returns (bool) {\n', '\t\trequire(from != address(0), "StrudelWrapper: address(0x0)");\n', '\t\tIStrudel(strdlAddr).burnFrom(from, amount);\n', '\t\treturn true;\n', '\t}\n', '\n', '\tfunction Swapin(bytes32 txhash, address account, uint256 amount) public onlyMinter returns (bool) {\n', '\t\tIStrudel(strdlAddr).mint(account, amount);\n', '\t\temit LogSwapin(txhash, account, amount);\n', '\t\treturn true;\n', '\t}\n', '\n', '\tfunction Swapout(uint256 amount, address bindaddr) public returns (bool) {\n', '\t\trequire(bindaddr != address(0), "StrudelWrapper: address(0x0)");\n', '\t\tIStrudel(strdlAddr).burnFrom(msg.sender, amount);\n', '\t\temit LogSwapout(msg.sender, bindaddr, amount);\n', '\t\treturn true;\n', '\t}\n', '\n', '\tfunction getAddr(bytes memory _extraData) internal pure returns (address){\n', '\t\taddress addr;\n', '\t\tassembly {\n', '\t\t\taddr := mload(add(_extraData,20))\n', '\t\t}\n', '\t\treturn addr;\n', '\t}\n', '\n', '\tfunction receiveApproval(\n', '\t\taddress _from,\n', '\t\tuint256 _value,\n', '\t\taddress _token,\n', '\t\tbytes calldata _extraData\n', '\t) external override {\n', '\t\trequire(msg.sender == strdlAddr, "StrudelWrapper: onlyAuth");\n', '\t\trequire(_token == strdlAddr, "StrudelWrapper: onlyAuth");\n', '\t\taddress bindaddr = getAddr(_extraData);\n', '\t\trequire(bindaddr != address(0), "StrudelWrapper: address(0x0)");\n', '\t\tIStrudel(strdlAddr).burnFrom(_from, _value);\n', '\t\temit LogSwapout(_from, bindaddr, _value);\n', '\t}\n', '}']