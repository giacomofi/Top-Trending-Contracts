['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-31\n', '*/\n', '\n', '// SPDX-License-Identifier: none\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'interface IERC20Metadata is IERC20 {\n', '    function name() external view returns (string memory);\n', '\n', '    function symbol() external view returns (string memory);\n', '\n', '    function decimals() external view returns (uint8);\n', '}\n', '\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes calldata) {\n', '        this;\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'contract ERC20 is Context, IERC20, IERC20Metadata {\n', '    mapping (address => uint256) private _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    string private _name;\n', '    string private _symbol;\n', '\n', '    constructor (string memory name_, string memory symbol_) {\n', '        _name = name_;\n', '        _symbol = symbol_;\n', '    }\n', '\n', '    function name() public view virtual override returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view virtual override returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public view virtual override returns (uint8) {\n', '        return 18;\n', '    }\n', '\n', '    function totalSupply() public view virtual override returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address account) public view virtual override returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '\n', '        uint256 currentAllowance = _allowances[sender][_msgSender()];\n', '        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");\n', '        _approve(sender, _msgSender(), currentAllowance - amount);\n', '\n', '        return true;\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);\n', '        return true;\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n', '        uint256 currentAllowance = _allowances[_msgSender()][spender];\n', '        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");\n', '        _approve(_msgSender(), spender, currentAllowance - subtractedValue);\n', '\n', '        return true;\n', '    }\n', '\n', '    function _transfer(address sender, address recipient, uint256 amount) internal virtual {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _beforeTokenTransfer(sender, recipient, amount);\n', '\n', '        uint256 senderBalance = _balances[sender];\n', '        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");\n', '        _balances[sender] = senderBalance - amount;\n', '        _balances[recipient] += amount;\n', '\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '    function _mint(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _beforeTokenTransfer(address(0), account, amount);\n', '\n', '        _totalSupply += amount;\n', '        _balances[account] += amount;\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '    function _burn(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _beforeTokenTransfer(account, address(0), amount);\n', '\n', '        uint256 accountBalance = _balances[account];\n', '        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");\n', '        _balances[account] = accountBalance - amount;\n', '        _totalSupply -= amount;\n', '\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '\n', '    function _approve(address owner, address spender, uint256 amount) internal virtual {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }\n', '}\n', '\n', 'abstract contract ERC20Burnable is Context, ERC20 {\n', '\n', '    function burn(uint256 amount) public virtual {\n', '        _burn(_msgSender(), amount);\n', '    }\n', '\n', '    function burnFrom(address account, uint256 amount) public virtual {\n', '        uint256 currentAllowance = allowance(account, _msgSender());\n', '        require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");\n', '        _approve(account, _msgSender(), currentAllowance - amount);\n', '        _burn(account, amount);\n', '    }\n', '}\n', '\n', 'library Math {\n', '\n', '    function max(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function average(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);\n', '    }\n', '}\n', '\n', 'library Arrays {\n', '\n', '    function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {\n', '        if (array.length == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 low = 0;\n', '        uint256 high = array.length;\n', '\n', '        while (low < high) {\n', '            uint256 mid = Math.average(low, high);\n', '\n', '            if (array[mid] > element) {\n', '                high = mid;\n', '            } else {\n', '                low = mid + 1;\n', '            }\n', '        }\n', '\n', '        if (low > 0 && array[low - 1] == element) {\n', '            return low - 1;\n', '        } else {\n', '            return low;\n', '        }\n', '    }\n', '}\n', '\n', 'library Counters {\n', '    struct Counter {\n', '        uint256 _value;\n', '    }\n', '\n', '    function current(Counter storage counter) internal view returns (uint256) {\n', '        return counter._value;\n', '    }\n', '\n', '    function increment(Counter storage counter) internal {\n', '        unchecked { counter._value += 1; }\n', '    }\n', '\n', '    function decrement(Counter storage counter) internal {\n', '        uint256 value = counter._value;\n', '        require(value > 0, "Counter: decrement overflow");\n', '        unchecked {\n', '            counter._value = value - 1;\n', '        }\n', '    }\n', '}\n', '\n', 'abstract contract ERC20Snapshot is ERC20 {\n', '\n', '    using Arrays for uint256[];\n', '    using Counters for Counters.Counter;\n', '\n', '    struct Snapshots {\n', '        uint256[] ids;\n', '        uint256[] values;\n', '    }\n', '\n', '    mapping (address => Snapshots) private _accountBalanceSnapshots;\n', '    Snapshots private _totalSupplySnapshots;\n', '\n', '    Counters.Counter private _currentSnapshotId;\n', '\n', '    event Snapshot(uint256 id);\n', '\n', '    function _snapshot() internal virtual returns (uint256) {\n', '        _currentSnapshotId.increment();\n', '\n', '        uint256 currentId = _currentSnapshotId.current();\n', '        emit Snapshot(currentId);\n', '        return currentId;\n', '    }\n', '\n', '    function balanceOfAt(address account, uint256 snapshotId) public view virtual returns (uint256) {\n', '        (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);\n', '\n', '        return snapshotted ? value : balanceOf(account);\n', '    }\n', '\n', '    function totalSupplyAt(uint256 snapshotId) public view virtual returns(uint256) {\n', '        (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);\n', '\n', '        return snapshotted ? value : totalSupply();\n', '    }\n', '\n', '\n', '    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {\n', '      super._beforeTokenTransfer(from, to, amount);\n', '\n', '      if (from == address(0)) {\n', '        _updateAccountSnapshot(to);\n', '        _updateTotalSupplySnapshot();\n', '      } else if (to == address(0)) {\n', '        _updateAccountSnapshot(from);\n', '        _updateTotalSupplySnapshot();\n', '      } else {\n', '        _updateAccountSnapshot(from);\n', '        _updateAccountSnapshot(to);\n', '      }\n', '    }\n', '\n', '    function _valueAt(uint256 snapshotId, Snapshots storage snapshots)\n', '        private view returns (bool, uint256)\n', '    {\n', '        require(snapshotId > 0, "ERC20Snapshot: id is 0");\n', '        require(snapshotId <= _currentSnapshotId.current(), "ERC20Snapshot: nonexistent id");\n', '\n', '        uint256 index = snapshots.ids.findUpperBound(snapshotId);\n', '\n', '        if (index == snapshots.ids.length) {\n', '            return (false, 0);\n', '        } else {\n', '            return (true, snapshots.values[index]);\n', '        }\n', '    }\n', '\n', '    function _updateAccountSnapshot(address account) private {\n', '        _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));\n', '    }\n', '\n', '    function _updateTotalSupplySnapshot() private {\n', '        _updateSnapshot(_totalSupplySnapshots, totalSupply());\n', '    }\n', '\n', '    function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {\n', '        uint256 currentId = _currentSnapshotId.current();\n', '        if (_lastSnapshotId(snapshots.ids) < currentId) {\n', '            snapshots.ids.push(currentId);\n', '            snapshots.values.push(currentValue);\n', '        }\n', '    }\n', '\n', '    function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {\n', '        if (ids.length == 0) {\n', '            return 0;\n', '        } else {\n', '            return ids[ids.length - 1];\n', '        }\n', '    }\n', '}\n', '\n', 'library Strings {\n', '    bytes16 private constant alphabet = "0123456789abcdef";\n', '\n', '    function toString(uint256 value) internal pure returns (string memory) {\n', '\n', '        if (value == 0) {\n', '            return "0";\n', '        }\n', '        uint256 temp = value;\n', '        uint256 digits;\n', '        while (temp != 0) {\n', '            digits++;\n', '            temp /= 10;\n', '        }\n', '        bytes memory buffer = new bytes(digits);\n', '        while (value != 0) {\n', '            digits -= 1;\n', '            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));\n', '            value /= 10;\n', '        }\n', '        return string(buffer);\n', '    }\n', '\n', '    function toHexString(uint256 value) internal pure returns (string memory) {\n', '        if (value == 0) {\n', '            return "0x00";\n', '        }\n', '        uint256 temp = value;\n', '        uint256 length = 0;\n', '        while (temp != 0) {\n', '            length++;\n', '            temp >>= 8;\n', '        }\n', '        return toHexString(value, length);\n', '    }\n', '\n', '    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {\n', '        bytes memory buffer = new bytes(2 * length + 2);\n', '        buffer[0] = "0";\n', '        buffer[1] = "x";\n', '        for (uint256 i = 2 * length + 1; i > 1; --i) {\n', '            buffer[i] = alphabet[value & 0xf];\n', '            value >>= 4;\n', '        }\n', '        require(value == 0, "Strings: hex length insufficient");\n', '        return string(buffer);\n', '    }\n', '\n', '}\n', '\n', 'interface IERC165 {\n', '    function supportsInterface(bytes4 interfaceId) external view returns (bool);\n', '}\n', '\n', 'abstract contract ERC165 is IERC165 {\n', '    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {\n', '        return interfaceId == type(IERC165).interfaceId;\n', '    }\n', '}\n', '\n', 'interface IAccessControl {\n', '    function hasRole(bytes32 role, address account) external view returns (bool);\n', '    function getRoleAdmin(bytes32 role) external view returns (bytes32);\n', '    function grantRole(bytes32 role, address account) external;\n', '    function revokeRole(bytes32 role, address account) external;\n', '    function renounceRole(bytes32 role, address account) external;\n', '}\n', '\n', 'abstract contract AccessControl is Context, IAccessControl, ERC165 {\n', '    struct RoleData {\n', '        mapping (address => bool) members;\n', '        bytes32 adminRole;\n', '    }\n', '\n', '    mapping (bytes32 => RoleData) private _roles;\n', '\n', '    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;\n', '\n', '    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);\n', '\n', '    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);\n', '\n', '    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);\n', '\n', '    modifier onlyRole(bytes32 role) {\n', '        _checkRole(role, _msgSender());\n', '        _;\n', '    }\n', '\n', '    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {\n', '        return interfaceId == type(IAccessControl).interfaceId\n', '            || super.supportsInterface(interfaceId);\n', '    }\n', '\n', '    function hasRole(bytes32 role, address account) public view override returns (bool) {\n', '        return _roles[role].members[account];\n', '    }\n', '\n', '    function _checkRole(bytes32 role, address account) internal view {\n', '        if(!hasRole(role, account)) {\n', '            revert(string(abi.encodePacked(\n', '                "AccessControl: account ",\n', '                Strings.toHexString(uint160(account), 20),\n', '                " is missing role ",\n', '                Strings.toHexString(uint256(role), 32)\n', '            )));\n', '        }\n', '    }\n', '\n', '    function getRoleAdmin(bytes32 role) public view override returns (bytes32) {\n', '        return _roles[role].adminRole;\n', '    }\n', '\n', '    function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {\n', '        _grantRole(role, account);\n', '    }\n', '\n', '    function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {\n', '        _revokeRole(role, account);\n', '    }\n', '\n', '    function renounceRole(bytes32 role, address account) public virtual override {\n', '        require(account == _msgSender(), "AccessControl: can only renounce roles for self");\n', '\n', '        _revokeRole(role, account);\n', '    }\n', '\n', '    function _setupRole(bytes32 role, address account) internal virtual {\n', '        _grantRole(role, account);\n', '    }\n', '\n', '    function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {\n', '        emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);\n', '        _roles[role].adminRole = adminRole;\n', '    }\n', '\n', '    function _grantRole(bytes32 role, address account) private {\n', '        if (!hasRole(role, account)) {\n', '            _roles[role].members[account] = true;\n', '            emit RoleGranted(role, account, _msgSender());\n', '        }\n', '    }\n', '\n', '    function _revokeRole(bytes32 role, address account) private {\n', '        if (hasRole(role, account)) {\n', '            _roles[role].members[account] = false;\n', '            emit RoleRevoked(role, account, _msgSender());\n', '        }\n', '    }\n', '}\n', '\n', 'abstract contract Pausable is Context {\n', '    event Paused(address account);\n', '\n', '    event Unpaused(address account);\n', '\n', '    bool private _paused;\n', '\n', '    constructor () {\n', '        _paused = false;\n', '    }\n', '\n', '    function paused() public view virtual returns (bool) {\n', '        return _paused;\n', '    }\n', '\n', '    modifier whenNotPaused() {\n', '        require(!paused(), "Pausable: paused");\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused() {\n', '        require(paused(), "Pausable: not paused");\n', '        _;\n', '    }\n', '\n', '    function _pause() internal virtual whenNotPaused {\n', '        _paused = true;\n', '        emit Paused(_msgSender());\n', '    }\n', '\n', '    function _unpause() internal virtual whenPaused {\n', '        _paused = false;\n', '        emit Unpaused(_msgSender());\n', '    }\n', '}\n', '\n', 'interface IERC20Permit {\n', '    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '\n', '    function nonces(address owner) external view returns (uint256);\n', '\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '}\n', '\n', 'library ECDSA {\n', '    function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {\n', '        bytes32 r;\n', '        bytes32 s;\n', '        uint8 v;\n', '\n', '        if (signature.length == 65) {\n', '            assembly {\n', '                r := mload(add(signature, 0x20))\n', '                s := mload(add(signature, 0x40))\n', '                v := byte(0, mload(add(signature, 0x60)))\n', '            }\n', '        } else if (signature.length == 64) {\n', '            assembly {\n', '                let vs := mload(add(signature, 0x40))\n', '                r := mload(add(signature, 0x20))\n', '                s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)\n', '                v := add(shr(255, vs), 27)\n', '            }\n', '        } else {\n', '            revert("ECDSA: invalid signature length");\n', '        }\n', '\n', '        return recover(hash, v, r, s);\n', '    }\n', '\n', '    function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {\n', '        require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature \'s\' value");\n', '        require(v == 27 || v == 28, "ECDSA: invalid signature \'v\' value");\n', '\n', '        address signer = ecrecover(hash, v, r, s);\n', '        require(signer != address(0), "ECDSA: invalid signature");\n', '\n', '        return signer;\n', '    }\n', '\n', '    function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {\n', '        return keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", hash));\n', '    }\n', '\n', '    function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {\n', '        return keccak256(abi.encodePacked("\\x19\\x01", domainSeparator, structHash));\n', '    }\n', '}\n', '\n', 'abstract contract EIP712 {\n', '    bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;\n', '    uint256 private immutable _CACHED_CHAIN_ID;\n', '\n', '    bytes32 private immutable _HASHED_NAME;\n', '    bytes32 private immutable _HASHED_VERSION;\n', '    bytes32 private immutable _TYPE_HASH;\n', '    constructor(string memory name, string memory version) {\n', '        bytes32 hashedName = keccak256(bytes(name));\n', '        bytes32 hashedVersion = keccak256(bytes(version));\n', '        bytes32 typeHash = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");\n', '        _HASHED_NAME = hashedName;\n', '        _HASHED_VERSION = hashedVersion;\n', '        _CACHED_CHAIN_ID = block.chainid;\n', '        _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);\n', '        _TYPE_HASH = typeHash;\n', '    }\n', '\n', '    function _domainSeparatorV4() internal view returns (bytes32) {\n', '        if (block.chainid == _CACHED_CHAIN_ID) {\n', '            return _CACHED_DOMAIN_SEPARATOR;\n', '        } else {\n', '            return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);\n', '        }\n', '    }\n', '\n', '    function _buildDomainSeparator(bytes32 typeHash, bytes32 name, bytes32 version) private view returns (bytes32) {\n', '        return keccak256(\n', '            abi.encode(\n', '                typeHash,\n', '                name,\n', '                version,\n', '                block.chainid,\n', '                address(this)\n', '            )\n', '        );\n', '    }\n', '\n', '    function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {\n', '        return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);\n', '    }\n', '}\n', '\n', 'abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {\n', '    using Counters for Counters.Counter;\n', '\n', '    mapping (address => Counters.Counter) private _nonces;\n', '\n', '    bytes32 private immutable _PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");\n', '\n', '    constructor(string memory name) EIP712(name, "1") {\n', '    }\n', '\n', '    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public virtual override {\n', '        require(block.timestamp <= deadline, "ERC20Permit: expired deadline");\n', '\n', '        bytes32 structHash = keccak256(\n', '            abi.encode(\n', '                _PERMIT_TYPEHASH,\n', '                owner,\n', '                spender,\n', '                value,\n', '                _useNonce(owner),\n', '                deadline\n', '            )\n', '        );\n', '\n', '        bytes32 hash = _hashTypedDataV4(structHash);\n', '\n', '        address signer = ECDSA.recover(hash, v, r, s);\n', '        require(signer == owner, "ERC20Permit: invalid signature");\n', '\n', '        _approve(owner, spender, value);\n', '    }\n', '\n', '    function nonces(address owner) public view virtual override returns (uint256) {\n', '        return _nonces[owner].current();\n', '    }\n', '\n', '    function DOMAIN_SEPARATOR() external view override returns (bytes32) {\n', '        return _domainSeparatorV4();\n', '    }\n', '\n', '    function _useNonce(address owner) internal virtual returns (uint256 current) {\n', '        Counters.Counter storage nonce = _nonces[owner];\n', '        current = nonce.current();\n', '        nonce.increment();\n', '    }\n', '}\n', '\n', 'contract Maj is ERC20, ERC20Burnable, ERC20Snapshot, AccessControl, Pausable, ERC20Permit {\n', '    bytes32 public constant SNAPSHOT_ROLE = keccak256("SNAPSHOT_ROLE");\n', '    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");\n', '\n', '    constructor() ERC20("Majal Coin", "MAJ") ERC20Permit("Majal Coin") {\n', '        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);\n', '        _setupRole(SNAPSHOT_ROLE, msg.sender);\n', '        _setupRole(PAUSER_ROLE, msg.sender);\n', '        _mint(msg.sender, 10000000000 * 10 ** decimals());\n', '    }\n', '\n', '    function snapshot() public {\n', '        require(hasRole(SNAPSHOT_ROLE, msg.sender));\n', '        _snapshot();\n', '    }\n', '\n', '    function pause() public {\n', '        require(hasRole(PAUSER_ROLE, msg.sender));\n', '        _pause();\n', '    }\n', '\n', '    function unpause() public {\n', '        require(hasRole(PAUSER_ROLE, msg.sender));\n', '        _unpause();\n', '    }\n', '\n', '    function _beforeTokenTransfer(address from, address to, uint256 amount)\n', '        internal\n', '        whenNotPaused\n', '        override(ERC20, ERC20Snapshot)\n', '    {\n', '        super._beforeTokenTransfer(from, to, amount);\n', '    }\n', '}']