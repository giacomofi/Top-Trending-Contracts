['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-17\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.6.2;\n', '\n', 'library EnumerableSet {\n', '    struct Set {\n', '        bytes32[] _values;\n', '        mapping (bytes32 => uint256) _indexes;\n', '    }\n', '\n', '    function _add(Set storage set, bytes32 value) private returns (bool) {\n', '        if (!_contains(set, value)) {\n', '            set._values.push(value);\n', '            set._indexes[value] = set._values.length;\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function _remove(Set storage set, bytes32 value) private returns (bool) {\n', '        uint256 valueIndex = set._indexes[value];\n', '\n', '        if (valueIndex != 0) {\n', '            uint256 toDeleteIndex = valueIndex - 1;\n', '            uint256 lastIndex = set._values.length - 1;\n', '\n', '            bytes32 lastvalue = set._values[lastIndex];\n', '\n', '            set._values[toDeleteIndex] = lastvalue;\n', '            set._indexes[lastvalue] = toDeleteIndex + 1;\n', '            set._values.pop();\n', '\n', '            delete set._indexes[value];\n', '\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function _contains(Set storage set, bytes32 value) private view returns (bool) {\n', '        return set._indexes[value] != 0;\n', '    }\n', '\n', '    function _length(Set storage set) private view returns (uint256) {\n', '        return set._values.length;\n', '    }\n', '\n', '    function _at(Set storage set, uint256 index) private view returns (bytes32) {\n', '        require(set._values.length > index, "EnumerableSet: index out of bounds");\n', '        return set._values[index];\n', '    }\n', '\n', '    struct AddressSet {\n', '        Set _inner;\n', '    }\n', '\n', '    function add(AddressSet storage set, address value) internal returns (bool) {\n', '        return _add(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '    function remove(AddressSet storage set, address value) internal returns (bool) {\n', '        return _remove(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '    function contains(AddressSet storage set, address value) internal view returns (bool) {\n', '        return _contains(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '    function length(AddressSet storage set) internal view returns (uint256) {\n', '        return _length(set._inner);\n', '    }\n', '\n', '    function at(AddressSet storage set, uint256 index) internal view returns (address) {\n', '        return address(uint256(_at(set._inner, index)));\n', '    }\n', '\n', '    struct UintSet {\n', '        Set _inner;\n', '    }\n', '\n', '    function add(UintSet storage set, uint256 value) internal returns (bool) {\n', '        return _add(set._inner, bytes32(value));\n', '    }\n', '\n', '    function remove(UintSet storage set, uint256 value) internal returns (bool) {\n', '        return _remove(set._inner, bytes32(value));\n', '    }\n', '\n', '    function contains(UintSet storage set, uint256 value) internal view returns (bool) {\n', '        return _contains(set._inner, bytes32(value));\n', '    }\n', '\n', '    function length(UintSet storage set) internal view returns (uint256) {\n', '        return _length(set._inner);\n', '    }\n', '\n', '    function at(UintSet storage set, uint256 index) internal view returns (uint256) {\n', '        return uint256(_at(set._inner, index));\n', '    }\n', '}\n', '\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        uint256 size;\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return _functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        return _functionCallWithValue(target, data, value, errorMessage);\n', '    }\n', '\n', '    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            if (returndata.length > 0) {\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'abstract contract AccessControl is Context {\n', '    using EnumerableSet for EnumerableSet.AddressSet;\n', '    using Address for address;\n', '\n', '    struct RoleData {\n', '        EnumerableSet.AddressSet members;\n', '        bytes32 adminRole;\n', '    }\n', '\n', '    mapping (bytes32 => RoleData) private _roles;\n', '\n', '    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;\n', '\n', '    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);\n', '    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);\n', '    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);\n', '\n', '    function hasRole(bytes32 role, address account) public view returns (bool) {\n', '        return _roles[role].members.contains(account);\n', '    }\n', '\n', '    function getRoleMemberCount(bytes32 role) public view returns (uint256) {\n', '        return _roles[role].members.length();\n', '    }\n', '\n', '    function getRoleMember(bytes32 role, uint256 index) public view returns (address) {\n', '        return _roles[role].members.at(index);\n', '    }\n', '\n', '    function getRoleAdmin(bytes32 role) public view returns (bytes32) {\n', '        return _roles[role].adminRole;\n', '    }\n', '\n', '    function grantRole(bytes32 role, address account) public virtual {\n', '        require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");\n', '\n', '        _grantRole(role, account);\n', '    }\n', '\n', '    function revokeRole(bytes32 role, address account) public virtual {\n', '        require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");\n', '\n', '        _revokeRole(role, account);\n', '    }\n', '\n', '    function renounceRole(bytes32 role, address account) public virtual {\n', '        require(account == _msgSender(), "AccessControl: can only renounce roles for self");\n', '\n', '        _revokeRole(role, account);\n', '    }\n', '\n', '    function _setupRole(bytes32 role, address account) internal virtual {\n', '        _grantRole(role, account);\n', '    }\n', '\n', '    function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {\n', '        emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);\n', '        _roles[role].adminRole = adminRole;\n', '    }\n', '\n', '    function _grantRole(bytes32 role, address account) private {\n', '        if (_roles[role].members.add(account)) {\n', '            emit RoleGranted(role, account, _msgSender());\n', '        }\n', '    }\n', '\n', '    function _revokeRole(bytes32 role, address account) private {\n', '        if (_roles[role].members.remove(account)) {\n', '            emit RoleRevoked(role, account, _msgSender());\n', '        }\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract ERC20 is Context, IERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    mapping (address => uint256) private _balances;\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '\n', '    uint256 private _totalSupply;\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '    constructor (string memory name, string memory symbol) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = 18;\n', '    }\n', '\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '    function totalSupply() public view override returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address account) public view override returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));\n', '        return true;\n', '    }\n', '\n', '    function _transfer(address sender, address recipient, uint256 amount) internal virtual {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _beforeTokenTransfer(sender, recipient, amount);\n', '\n', '        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '    function _mint(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _beforeTokenTransfer(address(0), account, amount);\n', '\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '    function _burn(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _beforeTokenTransfer(account, address(0), amount);\n', '\n', '        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '\n', '    function _approve(address owner, address spender, uint256 amount) internal virtual {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '    function _setupDecimals(uint8 decimals_) internal {\n', '        _decimals = decimals_;\n', '    }\n', '\n', '    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }\n', '}\n', '\n', 'abstract contract ERC20Burnable is Context, ERC20 {\n', '    function burn(uint256 amount) public virtual {\n', '        _burn(_msgSender(), amount);\n', '    }\n', '\n', '    function burnFrom(address account, uint256 amount) public virtual {\n', '        uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");\n', '\n', '        _approve(account, _msgSender(), decreasedAllowance);\n', '        _burn(account, amount);\n', '    }\n', '}\n', '\n', 'contract Lockable is Context {\n', '    event Locked(address account);\n', '    event Unlocked(address account);\n', '    \n', '    mapping(address => bool) private _locked;\n', '    \n', '    function locked(address _to) public view returns (bool) {\n', '        return _locked[_to];\n', '    }\n', '    \n', '    function _lock(address to) internal virtual {\n', '        require(to != address(0), "ERC20: lock to the zero address");\n', '        \n', '        _locked[to] = true;\n', '        emit Locked(to);\n', '    }\n', '    \n', '    function _unlock(address to) internal virtual {\n', '        require(to != address(0), "ERC20: lock to the zero address");\n', '\n', '        _locked[to] = false;\n', '        emit Unlocked(to);\n', '    }\n', '}\n', '\n', 'contract Pausable is Context {\n', '    event Paused(address account);\n', '    event Unpaused(address account);\n', '\n', '    bool private _paused;\n', '\n', '    constructor () internal {\n', '        _paused = false;\n', '    }\n', '\n', '    function paused() public view returns (bool) {\n', '        return _paused;\n', '    }\n', '\n', '    modifier whenNotPaused() {\n', '        require(!_paused, "Pausable: paused");\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused() {\n', '        require(_paused, "Pausable: not paused");\n', '        _;\n', '    }\n', '\n', '    function _pause() internal virtual whenNotPaused {\n', '        _paused = true;\n', '        emit Paused(_msgSender());\n', '    }\n', '\n', '    function _unpause() internal virtual whenPaused {\n', '        _paused = false;\n', '        emit Unpaused(_msgSender());\n', '    }\n', '}\n', '\n', 'abstract contract ERC20Pausable is ERC20, Pausable, Lockable {\n', '    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {\n', '        super._beforeTokenTransfer(from, to, amount);\n', '\n', '        require(!paused(), "ERC20Pausable: token transfer while paused");\n', '        require(!locked(from), "CustomLockable: token transfer while locked");\n', '    }\n', '}\n', '\n', 'contract ERC20PresetMinterPauser is Context, AccessControl, ERC20Burnable, ERC20Pausable {\n', '    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");\n', '    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");\n', '\n', '    constructor(string memory name, string memory symbol) public ERC20(name, symbol) {\n', '        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());\n', '        _setupRole(MINTER_ROLE, _msgSender());\n', '        _setupRole(PAUSER_ROLE, _msgSender());\n', '    }\n', '\n', '    function mint(address to, uint256 amount) public virtual {\n', '        require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");\n', '        _mint(to, amount);\n', '    }\n', '\n', '    function pause() public virtual {\n', '        require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");\n', '        _pause();\n', '    }\n', '\n', '    function unpause() public virtual {\n', '        require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");\n', '        _unpause();\n', '    }\n', '    \n', '    function lock(address to) public virtual {\n', '        require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to lock");\n', '        _lock(to);\n', '    }\n', '\n', '    function unlock(address to) public virtual {\n', '        require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unlock");\n', '        _unlock(to);\n', '    }\n', '\n', '    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {\n', '        super._beforeTokenTransfer(from, to, amount);\n', '    }\n', '}\n', '\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract MRToken is Ownable, ERC20PresetMinterPauser {\n', '    constructor ()\n', '        ERC20PresetMinterPauser("MiningRevolution", "MR")\n', '        public\n', '    {\n', '        mint(msg.sender, 1*(10**8)*(10**uint256(decimals())) );\n', '    }\n', '}']