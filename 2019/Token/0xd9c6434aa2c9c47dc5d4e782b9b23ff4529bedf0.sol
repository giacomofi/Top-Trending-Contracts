['pragma solidity ^0.5.0;\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/access/Roles.sol\n', '\n', '/**\n', ' * @title Roles\n', ' * @dev Library for managing addresses assigned to a Role.\n', ' */\n', 'library Roles {\n', '    struct Role {\n', '        mapping (address => bool) bearer;\n', '    }\n', '\n', '    /**\n', '     * @dev give an account access to this role\n', '     */\n', '    function add(Role storage role, address account) internal {\n', '        require(account != address(0));\n', '        require(!has(role, account));\n', '\n', '        role.bearer[account] = true;\n', '    }\n', '\n', '    /**\n', "     * @dev remove an account's access to this role\n", '     */\n', '    function remove(Role storage role, address account) internal {\n', '        require(account != address(0));\n', '        require(has(role, account));\n', '\n', '        role.bearer[account] = false;\n', '    }\n', '\n', '    /**\n', '     * @dev check if an account has this role\n', '     * @return bool\n', '     */\n', '    function has(Role storage role, address account) internal view returns (bool) {\n', '        require(account != address(0));\n', '        return role.bearer[account];\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol\n', '\n', 'contract PauserRole {\n', '    using Roles for Roles.Role;\n', '\n', '    event PauserAdded(address indexed account);\n', '    event PauserRemoved(address indexed account);\n', '\n', '    Roles.Role private _pausers;\n', '\n', '    constructor () internal {\n', '        _addPauser(msg.sender);\n', '    }\n', '\n', '    modifier onlyPauser() {\n', '        require(isPauser(msg.sender));\n', '        _;\n', '    }\n', '\n', '    function isPauser(address account) public view returns (bool) {\n', '        return _pausers.has(account);\n', '    }\n', '\n', '    function addPauser(address account) public onlyPauser {\n', '        _addPauser(account);\n', '    }\n', '\n', '    function renouncePauser() public {\n', '        _removePauser(msg.sender);\n', '    }\n', '\n', '    function _addPauser(address account) internal {\n', '        _pausers.add(account);\n', '        emit PauserAdded(account);\n', '    }\n', '\n', '    function _removePauser(address account) internal {\n', '        _pausers.remove(account);\n', '        emit PauserRemoved(account);\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is PauserRole {\n', '    event Paused(address account);\n', '    event Unpaused(address account);\n', '\n', '    bool private _paused;\n', '\n', '    constructor () internal {\n', '        _paused = false;\n', '    }\n', '\n', '    /**\n', '     * @return true if the contract is paused, false otherwise.\n', '     */\n', '    function paused() public view returns (bool) {\n', '        return _paused;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!_paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(_paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() public onlyPauser whenNotPaused {\n', '        _paused = true;\n', '        emit Paused(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() public onlyPauser whenPaused {\n', '        _paused = false;\n', '        emit Unpaused(msg.sender);\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @return the address of the owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner());\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @return true if `msg.sender` is the owner of the contract.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to relinquish control of the contract.\n', '     * @notice Renouncing to ownership will leave the contract without an owner.\n', '     * It will not be possible to call the functions with the `onlyOwner`\n', '     * modifier anymore.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/IAlkionToken.sol\n', '\n', '/**\n', ' * @title AlkionToken interface based ERC-20\n', ' * @dev www.alkion.io  \n', ' */\n', 'interface IAlkionToken {\n', '    function transfer(address sender, address to, uint256 value) external returns (bool);\n', '    function approve(address sender, address spender, uint256 value) external returns (bool);\n', '    function transferFrom(address sender, address from, address to, uint256 value) external returns (uint256);\n', '\tfunction burn(address sender, uint256 value) external;\n', '\tfunction burnFrom(address sender, address from, uint256 value) external returns(uint256);\n', '\t\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address who) external view returns (uint256);\n', '\tfunction totalBalanceOf(address who) external view returns (uint256);\n', '\tfunction lockedBalanceOf(address who) external view returns (uint256);     \n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\t\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);    \n', '}\n', '\n', '// File: contracts/AlkionToken.sol\n', '\n', '/**\n', ' * @title Alkion Token\n', ' * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.\n', ' * Note they can later distribute these tokens as they wish using `transfer` and other\n', ' * `ERC20` functions.\n', ' */\n', 'contract AlkionToken is IERC20, Pausable, Ownable {\n', '\n', "\tstring internal constant NOT_OWNER = 'You are not owner';\n", "\tstring internal constant INVALID_TARGET_ADDRESS = 'Invalid target address';\n", '\t\n', '\tIAlkionToken internal _tokenImpl;\n', '\t\t\n', '\tmodifier onlyOwner() {\n', '\t\trequire(isOwner(), NOT_OWNER);\n', '\t\t_;\n', '\t}\n', '\t\t\n', '\tconstructor() \n', '\t\tpublic \n', '\t{\t\n', '\t}\n', '\t\n', '\tfunction impl(IAlkionToken tokenImpl)\n', '\t\tonlyOwner \n', '\t\tpublic \n', '\t{\n', '\t\trequire(address(tokenImpl) != address(0), INVALID_TARGET_ADDRESS);\n', '\t\t_tokenImpl = tokenImpl;\n', '\t}\n', '\t\n', '\tfunction addressImpl() \n', '\t\tpublic \n', '\t\tview \n', '\t\treturns (address) \n', '\t{\n', '\t\tif(!isOwner()) return address(0);\n', '\t\treturn address(_tokenImpl);\n', '\t} \n', '\t\n', '\tfunction totalSupply() \n', '\t\tpublic \n', '\t\tview \n', '\t\treturns (uint256) \n', '\t{\n', '\t\treturn _tokenImpl.totalSupply();\n', '\t}\n', '\t\n', '\tfunction balanceOf(address who) \n', '\t\tpublic \n', '\t\tview \n', '\t\treturns (uint256) \n', '\t{\n', '\t\treturn _tokenImpl.balanceOf(who);\n', '\t}\n', '\t\n', '\tfunction allowance(address owner, address spender)\n', '\t\tpublic \n', '\t\tview \n', '\t\treturns (uint256) \n', '\t{\n', '\t\treturn _tokenImpl.allowance(owner, spender);\n', '\t}\n', '\t\n', '\tfunction transfer(address to, uint256 value) \n', '\t\twhenNotPaused \n', '\t\tpublic \n', '\t\treturns (bool result) \n', '\t{\n', '\t\tresult = _tokenImpl.transfer(msg.sender, to, value);\n', '\t\temit Transfer(msg.sender, to, value);\n', '\t}\n', '\t\n', '\tfunction approve(address spender, uint256 value)\n', '\t\twhenNotPaused \n', '\t\tpublic \n', '\t\treturns (bool result) \n', '\t{\n', '\t\tresult = _tokenImpl.approve(msg.sender, spender, value);\n', '\t\temit Approval(msg.sender, spender, value);\n', '\t}\n', '\t\n', '\tfunction transferFrom(address from, address to, uint256 value)\n', '\t\twhenNotPaused \n', '\t\tpublic \n', '\t\treturns (bool) \n', '\t{\n', '\t\tuint256 aB = _tokenImpl.transferFrom(msg.sender, from, to, value);\n', '\t\temit Transfer(from, to, value);\n', '\t\temit Approval(from, msg.sender, aB);\n', '\t\treturn true;\n', '\t}\n', '\t\n', '\tfunction burn(uint256 value) \n', '\t\tpublic \n', '\t{\n', '\t\t_tokenImpl.burn(msg.sender, value);\n', '\t\temit Transfer(msg.sender, address(0), value);\n', '\t}\n', '\n', '\tfunction burnFrom(address from, uint256 value) \n', '\t\tpublic \n', '\t{\n', '\t\tuint256 aB = _tokenImpl.burnFrom(msg.sender, from, value);\n', '\t\temit Transfer(from, address(0), value);\n', '\t\temit Approval(from, msg.sender, aB);\n', '\t}\n', '\n', '\tfunction totalBalanceOf(address _of) \n', '\t\tpublic \n', '\t\tview \n', '\t\treturns (uint256)\n', '\t{\n', '\t\treturn _tokenImpl.totalBalanceOf(_of);\n', '\t}\n', '\t\n', '\tfunction lockedBalanceOf(address _of) \n', '\t\tpublic \n', '\t\tview \n', '\t\treturns (uint256)\n', '\t{\n', '\t\treturn _tokenImpl.lockedBalanceOf(_of);\n', '\t}\n', '}']