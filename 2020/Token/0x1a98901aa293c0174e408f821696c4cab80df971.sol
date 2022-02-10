['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7;\n', '\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; \n', '        return msg.data;\n', '    }\n', '}\n', '\n', '\n', 'library Address {\n', '\n', '    function isContract(address account) internal view returns (bool) {\n', '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return _functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        return _functionCallWithValue(target, data, value, errorMessage);\n', '    }\n', '\n', '    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '\n', '            if (returndata.length > 0) {\n', '\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'library EnumerableSet {\n', '\n', '    struct Set {\n', '        bytes32[] _values;\n', '        mapping (bytes32 => uint256) _indexes;\n', '    }\n', '\n', '    function _add(Set storage set, bytes32 value) private returns (bool) {\n', '        if (!_contains(set, value)) {\n', '            set._values.push(value);\n', '            set._indexes[value] = set._values.length;\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function _remove(Set storage set, bytes32 value) private returns (bool) {\n', '\n', '        uint256 valueIndex = set._indexes[value];\n', '\n', '        if (valueIndex != 0) {\n', '\n', '            uint256 toDeleteIndex = valueIndex - 1;\n', '            uint256 lastIndex = set._values.length - 1;\n', '            bytes32 lastvalue = set._values[lastIndex];\n', '            set._values[toDeleteIndex] = lastvalue;\n', '            set._indexes[lastvalue] = toDeleteIndex + 1;\n', '            set._values.pop();\n', '            delete set._indexes[value];\n', '            return true;\n', '            \n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function _contains(Set storage set, bytes32 value) private view returns (bool) {\n', '        return set._indexes[value] != 0;\n', '    }\n', '\n', '    function _length(Set storage set) private view returns (uint256) {\n', '        return set._values.length;\n', '    }\n', '\n', '    function _at(Set storage set, uint256 index) private view returns (bytes32) {\n', '        require(set._values.length > index, "EnumerableSet: index out of bounds");\n', '        return set._values[index];\n', '    }\n', '\n', '    struct AddressSet {\n', '        Set _inner;\n', '    }\n', '\n', '    function add(AddressSet storage set, address value) internal returns (bool) {\n', '        return _add(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '    function remove(AddressSet storage set, address value) internal returns (bool) {\n', '        return _remove(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '    function contains(AddressSet storage set, address value) internal view returns (bool) {\n', '        return _contains(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '    function length(AddressSet storage set) internal view returns (uint256) {\n', '        return _length(set._inner);\n', '    }\n', '\n', '    function at(AddressSet storage set, uint256 index) internal view returns (address) {\n', '        return address(uint256(_at(set._inner, index)));\n', '    }\n', '\n', '    struct UintSet {\n', '        Set _inner;\n', '    }\n', '\n', '    function add(UintSet storage set, uint256 value) internal returns (bool) {\n', '        return _add(set._inner, bytes32(value));\n', '    }\n', '\n', '    function remove(UintSet storage set, uint256 value) internal returns (bool) {\n', '        return _remove(set._inner, bytes32(value));\n', '    }\n', '\n', '    function contains(UintSet storage set, uint256 value) internal view returns (bool) {\n', '        return _contains(set._inner, bytes32(value));\n', '    }\n', '\n', '    function length(UintSet storage set) internal view returns (uint256) {\n', '        return _length(set._inner);\n', '    }\n', '\n', '    function at(UintSet storage set, uint256 index) internal view returns (uint256) {\n', '        return uint256(_at(set._inner, index));\n', '    }\n', '}\n', '\n', '\n', 'library SafeMath {\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', 'abstract contract AccessControl is Context {\n', '    using EnumerableSet for EnumerableSet.AddressSet;\n', '    using Address for address;\n', '\n', '    struct RoleData {\n', '        EnumerableSet.AddressSet members;\n', '        bytes32 adminRole;\n', '    }\n', '\n', '    mapping (bytes32 => RoleData) private _roles;\n', '\n', '    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;\n', '    bytes32 public constant MINTER_ROLE = "MINTER";\n', '\n', '    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);\n', '\n', '    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);\n', '\n', '    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);\n', '\n', '    function hasRole(bytes32 role, address account) public view returns (bool) {\n', '        return _roles[role].members.contains(account);\n', '    }\n', '\n', '    function getRoleMemberCount(bytes32 role) public view returns (uint256) {\n', '        return _roles[role].members.length();\n', '    }\n', '\n', '    function getRoleMember(bytes32 role, uint256 index) public view returns (address) {\n', '        return _roles[role].members.at(index);\n', '    }\n', '\n', '    function getRoleAdmin(bytes32 role) public view returns (bytes32) {\n', '        return _roles[role].adminRole;\n', '    }\n', '\n', '    function grantRole(bytes32 role, address account) public virtual {\n', '        require(hasRole(_roles[DEFAULT_ADMIN_ROLE].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");\n', '        require(!hasRole(_roles[DEFAULT_ADMIN_ROLE].adminRole, account), "AccessControl: admin cannot grant himself");\n', '        require(DEFAULT_ADMIN_ROLE != role, "AccessControl: cannot grant adminRole");\n', '        _grantRole(role, account);\n', '    }\n', '    \n', '    function transferAdminRole(address account) public virtual {\n', '        require(hasRole(_roles[DEFAULT_ADMIN_ROLE].adminRole, _msgSender()), "AccessControl: sender must be an admin to transfer");\n', '        require(_roles[DEFAULT_ADMIN_ROLE].members.at(0) != account, "AccessControl: admin cannot transfer himself");\n', '        _removeRole(DEFAULT_ADMIN_ROLE, _msgSender());\n', '        _setupRole(DEFAULT_ADMIN_ROLE, account);\n', '        _removeRole(MINTER_ROLE, _msgSender());\n', '        _setupRole(MINTER_ROLE, account);\n', '    }    \n', '\n', '    function revokeRole(bytes32 role, address account) public virtual {\n', '        require(hasRole(_roles[DEFAULT_ADMIN_ROLE].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");\n', '        require(!hasRole(_roles[DEFAULT_ADMIN_ROLE].adminRole, account), "AccessControl: admin cannot revoke himself");\n', '        _revokeRole(role, account);\n', '    }\n', '\n', '    function renounceRole(bytes32 role, address account) public virtual {\n', '        require(account == _msgSender(), "AccessControl: can only renounce roles for self");\n', '        require(!hasRole(_roles[DEFAULT_ADMIN_ROLE].adminRole, account), "AccessControl: admin cannot renounce himself");\n', '        _revokeRole(role, account);\n', '    }\n', '\n', '    function _setupRole(bytes32 role, address account) internal virtual {\n', '        _grantRole(role, account);\n', '    }\n', '\n', '    function _removeRole(bytes32 role, address account) internal virtual {\n', '        _revokeRole(role, account);\n', '    }\n', '\n', '    function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {\n', '        emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);\n', '        _roles[role].adminRole = adminRole;\n', '    }\n', '\n', '    function _grantRole(bytes32 role, address account) private {\n', '        if (_roles[role].members.add(account)) {\n', '            emit RoleGranted(role, account, _msgSender());\n', '        }\n', '    }\n', '\n', '    function _revokeRole(bytes32 role, address account) private {\n', '        if (_roles[role].members.remove(account)) {\n', '            emit RoleRevoked(role, account, _msgSender());\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'interface IERC20 {\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    event Stake(address account);    \n', '\n', '    event Config(address account); \n', '    \n', '}\n', '\n', 'contract Pausable is Context {\n', '\n', '    event Paused(address account);\n', '    event Unpaused(address account);\n', '    bool private _paused;\n', '\n', '    constructor () {\n', '        _paused = false;\n', '    }\n', '\n', '    function paused() public view returns (bool) {\n', '        return _paused;\n', '    }\n', '\n', '    modifier whenNotPaused() {\n', '        require(!_paused, "Pausable: paused");\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused() {\n', '        require(_paused, "Pausable: not paused");\n', '        _;\n', '    }\n', '\n', '    function _pause() internal virtual whenNotPaused {\n', '        _paused = true;\n', '        emit Paused(_msgSender());\n', '    }\n', '\n', '    function _unpause() internal virtual whenPaused {\n', '        _paused = false;\n', '        emit Unpaused(_msgSender());\n', '    }\n', '}\n', '\n', '\n', 'contract WMART is Context, IERC20, AccessControl, Pausable {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    mapping(address => uint256) private _balances;\n', '\n', '    mapping(address => mapping(address => uint256)) private _allowances;\n', ' \n', '    struct stake {\n', '        uint256 timestamp;\n', '        uint256 stakeAmount;\n', '    }\n', '    \n', '    mapping(address => stake) private _stake;\n', '\n', '    string private _name;\n', '    string private _symbol;\n', '    bool private _staking;\n', '    uint8 private _decimals;\n', '    uint256 private _totalSupply;\n', '    uint256 private _reward;\n', '    uint256 private _rewardDuration;\n', '    uint256 private _collateral;\n', '    uint256 private _maxSupply;\n', '    uint256 private _lockTime;\n', '    uint256 private _totalStake;\n', '    uint256 private _maxTxLimit;\n', '  \n', '    constructor () {\n', '        _name = "Wrapped Martkist";\n', '        _symbol = "WMARTK";\n', '        _decimals = 8;\n', '        _maxSupply = 3700000000000000;\n', '        _reward = 1200000000;\n', '        _rewardDuration = 86400;\n', '        _collateral = 1800000000000; \n', '        _lockTime = 2592000;\n', '        _maxTxLimit = 200;\n', '        _staking = true;\n', '        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());\n', '        _setupRole(MINTER_ROLE, _msgSender());        \n', '    }    \n', '\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '    function totalSupply() public view override returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address account) public view override returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '    \n', '    function maxSupply() public view returns (uint256) {\n', '        return _maxSupply;\n', '    }\n', '    \n', '    function reward() public view returns (uint256) {\n', '        return _reward;\n', '    }\n', '\n', '    function collateral() public view returns (uint256) {\n', '        return _collateral;\n', '    }\n', '\n', '    function rewardDuration() public view returns (uint256) {\n', '        return _rewardDuration;\n', '    }\n', '    \n', '    function lockTime() public view returns (uint256) {\n', '        return _lockTime;\n', '    }    \n', '    \n', '    function isStaking() public view virtual returns (bool) {\n', '       return _staking; \n', '    } \n', '    \n', '    function maxTxLimit() public view virtual returns (uint256) {\n', '       return _maxTxLimit; \n', '    }       \n', '    \n', '    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));\n', '        return true;\n', '    }\n', '    \n', '    function stakeClaimDate(address account) public view virtual returns (uint256) {\n', '        if(_stake[account].stakeAmount > 0){\n', '            return _stake[account].timestamp.add(_lockTime);\n', '        }else{\n', '            return 0;\n', '        }\n', '    }\n', '    \n', '    function stakeBalance(address account) public view virtual returns (uint256) {\n', '       return _stake[account].stakeAmount; \n', '    } \n', '    \n', '    function stakeReward(address account) public view virtual returns (uint256) {\n', '        uint256 diff = (block.timestamp.sub(_stake[account].timestamp)).div(_rewardDuration);\n', '        uint256 stakereward = diff.mul(_reward);\n', '        if((_totalSupply.add(stakereward)) > _maxSupply){\n', '            stakereward = 0;\n', '        }\n', '        return stakereward;\n', '    }    \n', '    \n', '    function stakeDetails(address account) public view virtual returns (uint256, uint256, uint256) {\n', '        uint256 stakeamount = _stake[account].stakeAmount;\n', '        if(stakeamount > 0){\n', '            uint256 diff = (block.timestamp.sub(_stake[account].timestamp)).div(_rewardDuration);\n', '            uint256 stakereward = diff.mul(_reward);\n', '\n', '            if((_totalSupply.add(stakereward)) > _maxSupply){\n', '                stakereward = 0;\n', '            }            \n', '            return (stakeamount, stakereward, _stake[account].timestamp.add(_lockTime));\n', '        }else{\n', '            return (0, 0, 0);\n', '        }\n', '    }   \n', '    \n', '    function stakingPause() public virtual {\n', '        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "ERC20: Only ADMIN can pause staking");\n', '        require(_staking, "Staking: paused already");\n', '        _staking = false;\n', '        emit Stake(_msgSender());\n', '    }\n', '\n', '    function stakingUnpause() public virtual {\n', '        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "ERC20: Only ADMIN can unpause staking");\n', '        require(!_staking, "Staking: unpaused already");\n', '        _staking = true;\n', '        emit Stake(_msgSender());\n', '    }     \n', '    \n', '    function totalStakeBalance() public view virtual returns (uint256) {\n', '       return _totalStake; \n', '    }  \n', '    \n', '    function changeConfig(uint256 types, uint256 value) public virtual {\n', '        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Only ADMIN can change config");\n', '        if(types == 1){\n', '        require(value >= _totalSupply, "Value is less than current total supply");    \n', '        _maxSupply = value;\n', '        } else if(types == 2){\n', '        _reward = value;\n', '        } else if(types == 3){\n', '        _rewardDuration = value; \n', '        } else if(types == 4){\n', '        _collateral = value; \n', '        } else if(types == 5){\n', '        _lockTime = value;  \n', '        } else if(types == 6){\n', '        _maxTxLimit = value;  \n', '        }\n', '        emit Config(_msgSender());\n', '    }\n', '    \n', '    function increaseStake() public virtual {\n', '        uint256 amount = _collateral;\n', '        require(!paused(), "ERC20: Token paused by ADMIN");\n', '        require(_staking, "Staking: paused");\n', '        require(_stake[_msgSender()].stakeAmount > 0, "Not Staking");\n', '        require(_totalSupply <= _maxSupply, "Exceeds Max Supply, you can\'t stake more");\n', '        _balances[_msgSender()] = _balances[_msgSender()].sub(amount, "Stake amount 18000 exceeds balance");\n', '        uint256 diff = (block.timestamp.sub(_stake[_msgSender()].timestamp)).div(_rewardDuration);\n', '        uint256 stakeamount = diff.mul(_reward);\n', '        if((_totalSupply.add(stakeamount)) > _maxSupply){\n', '            stakeamount = 0;\n', '        }\n', '        _totalSupply = _totalSupply.add(stakeamount);\n', '        _balances[_msgSender()] = _balances[_msgSender()].add(stakeamount);\n', '        _stake[_msgSender()].timestamp = block.timestamp;\n', '        _stake[_msgSender()].stakeAmount = _stake[_msgSender()].stakeAmount.add(amount);\n', '        _totalStake = _totalStake.add(amount);\n', '        emit Transfer(_msgSender(), address(0), amount);\n', '        emit Transfer(address(0), _msgSender(), stakeamount);\n', '    }\n', '    \n', '    function claimStake() public virtual {\n', '        require(!paused(), "ERC20: Token paused by ADMIN");        \n', '        require(_stake[_msgSender()].stakeAmount > 0, "Not Staking");\n', '        require(block.timestamp >= (_stake[_msgSender()].timestamp + _lockTime), "Stake claim date not reached");\n', '        uint256 diff = (block.timestamp.sub(_stake[_msgSender()].timestamp)).div(_rewardDuration);\n', '        uint256 stakeamount = diff.mul(_reward);\n', '        uint256 totstakeamount = _stake[_msgSender()].stakeAmount + stakeamount;\n', '        if((_totalSupply.add(stakeamount)) > _maxSupply){\n', '            stakeamount = 0;\n', '        }         \n', '        _totalSupply = _totalSupply.add(stakeamount);\n', '        _balances[_msgSender()] = _balances[_msgSender()].add(totstakeamount);\n', '        _totalStake = _totalStake.sub(_stake[_msgSender()].stakeAmount);\n', '        _stake[_msgSender()].stakeAmount = 0;\n', '        _stake[_msgSender()].timestamp = 0;\n', '        emit Transfer(address(0), _msgSender(), totstakeamount);\n', '    }    \n', '\n', '    function startStake() public virtual {\n', '        uint256 amount = _collateral;\n', '        require(!paused(), "ERC20: Token paused by ADMIN");\n', '        require(_staking, "Staking: paused");\n', '        require(!(_stake[_msgSender()].stakeAmount > 0), "ALready Staking, use increaseStake");\n', '        require(_totalSupply <= _maxSupply, "Exceeds Max Supply, you can\'t stake more");\n', '        _balances[_msgSender()] = _balances[_msgSender()].sub(amount, "Stake amount 18000 exceeds balance");\n', '        _stake[_msgSender()].timestamp = block.timestamp; \n', '        _stake[_msgSender()].stakeAmount = amount;\n', '        _totalStake = _totalStake.add(amount);\n', '        emit Transfer(_msgSender(), address(0), amount);\n', '    }\n', '\n', '    \n', '\tfunction transferMulti(address[] memory to, uint256[] memory amount) public virtual {\n', '\t    uint256 sum_ = 0;\n', '\t    require(!paused(), "ERC20: Token paused by ADMIN");\n', '        require(_msgSender() != address(0), "Transfer from the zero address");\n', '\t\trequire(to.length == amount.length, "Address array length not equal to value");\n', '\t\trequire(to.length <= _maxTxLimit, "Payout list greater than _maxTxLimit");\n', '        for (uint8 g = 0; g < to.length; g++) {\n', '            require(to[g] != address(0), "Transfer to the zero address");\n', '            sum_ += amount[g];            \n', '        }\t\t\n', '        require(_balances[_msgSender()] >= sum_, "Transfer amount exceeds balance");\n', '\t\tfor (uint8 i = 0; i < to.length; i++) {\n', '\t\t    _transfer(_msgSender(), to[i], amount[i]);\n', '\t\t}\n', '\t}\t\n', '\t\n', '\tfunction transferMultiFrom(address sender, address[] memory to, uint256[] memory amount) public virtual {\n', '\t    uint256 sum_ = 0;\n', '\t    require(!paused(), "ERC20: Token paused by ADMIN");\n', '        require(sender != address(0), "Transfer from the zero address");\n', '\t\trequire(to.length == amount.length, "Address array length not equal to amount");\n', '\t\trequire(to.length <= _maxTxLimit, "Payout list greater than _maxTxLimit");\n', '        for (uint8 g = 0; g < to.length; g++) {\n', '            require(to[g] != address(0), "Transfer to the zero address");\n', '            sum_ += amount[g];\n', '        }\t\t\n', '        require(_balances[sender] >= sum_, "Transfer amount exceeds balance");\n', '        require(_allowances[sender][_msgSender()] >= sum_, "Transfer amount exceeds allowance");\n', '\t\tfor (uint8 i = 0; i < to.length; i++) {\n', '            _transfer(sender, to[i], amount[i]);\n', '            _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount[i], "ERC20: transfer amount exceeds allowance"));\n', '\t\t}\n', '\t}\n', '\t\n', '    function mint(address to, uint256 amount) public virtual {\n', '        require(hasRole(MINTER_ROLE, _msgSender()), "ERC20: Only MINTER can Mint");\n', '        require((_totalSupply.add(amount)) <= _maxSupply, "Exceeds Max Supply");\n', '        _mint(to, amount);\n', '    }\n', '    \n', '    function mintMulti(address[] memory to, uint256[] memory amount) public virtual {\n', '        uint256 sum_ = 0;\n', '        require(!paused(), "ERC20: Token paused by ADMIN");        \n', '        require(hasRole(MINTER_ROLE, _msgSender()), "ERC20: Only MINTER can Mint");\n', '\t\trequire(to.length == amount.length, "Address array length not equal to amount");\n', '\t\trequire(to.length <= _maxTxLimit, "Payout list greater than _maxTxLimit");        \n', '        for (uint8 g = 0; g < to.length; g++) {\n', '            require(to[g] != address(0), "ERC20: mint to the zero address");\n', '            sum_ += amount[g];\n', '        }\n', '        require((_totalSupply.add(sum_)) <= _maxSupply, "Exceeds Max Supply");\n', '\t\tfor (uint8 i = 0; i < to.length; i++) {\n', '\t\t    _mint(to[i], amount[i]);\n', '\t\t}        \n', '    }    \n', '    \n', '    function burn(uint256 amount) public virtual {\n', '        _burn(_msgSender(), amount);\n', '    }\n', '\n', '    function burnFrom(address account, uint256 amount) public virtual {\n', '        uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");\n', '        _approve(account, _msgSender(), decreasedAllowance);\n', '        _burn(account, amount);\n', '    }  \n', '    \n', '    function burnMultiFrom(address[] memory account, uint256[] memory amount) public virtual {\n', '        require(!paused(), "ERC20: Token paused by ADMIN");\n', '\t\trequire(account.length == amount.length, "Address array length not equal to amount");\n', '\t\trequire(account.length <= _maxTxLimit, "Payout list greater than _maxTxLimit");  \n', '        for (uint8 g = 0; g < account.length; g++) {\n', '            require(account[g] != address(0), "ERC20: burn from the zero address");\n', '            require(_balances[account[g]] >= amount[g], "ERC20: burn amount exceeds balance");\n', '            require(_allowances[account[g]][_msgSender()] >= amount[g], "Transfer amount exceeds allowance");\n', '        }\n', '\t\tfor (uint8 i = 0; i < account.length; i++) {\n', '            uint256 decreasedAllowance = allowance(account[i], _msgSender()).sub(amount[i], "ERC20: burn amount exceeds allowance");\n', '            _approve(account[i], _msgSender(), decreasedAllowance);\n', '            _burn(account[i], amount[i]);\n', '\t\t}          \n', '    }     \n', '    \n', '    function pause() public virtual {\n', '        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "ERC20: Only ADMIN can pause transfer");\n', '        _pause();\n', '    }\n', '\n', '    function unpause() public virtual {\n', '        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "ERC20: Only ADMIN can unpause transfer");\n', '        _unpause();\n', '    }    \n', '\n', '    function _transfer(address sender, address recipient, uint256 amount) internal virtual {\n', '        require(!paused(), "ERC20: Token paused by ADMIN");\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '    function _mint(address account, uint256 amount) internal virtual {\n', '        require(!paused(), "ERC20: Token paused by ADMIN");\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '    function _burn(address account, uint256 amount) internal virtual {\n', '        require(!paused(), "ERC20: Token paused by ADMIN");\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '\n', '    function _approve(address owner, address spender, uint256 amount) internal virtual {\n', '        require(!paused(), "ERC20: Token paused by ADMIN");\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '}']