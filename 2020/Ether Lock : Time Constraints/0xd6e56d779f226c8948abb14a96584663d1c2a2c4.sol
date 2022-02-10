['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.6.0;\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'pragma solidity ^0.6.0;\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.6.2;\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return _functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        return _functionCallWithValue(target, data, value, errorMessage);\n', '    }\n', '\n', '    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            if (returndata.length > 0) {\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.6.0;\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function _callOptionalReturn(IERC20 token, bytes memory data) private {\n', '        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");\n', '        if (returndata.length > 0) {\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.6.0;\n', 'library EnumerableSet {\n', '    struct Set {\n', '        bytes32[] _values;\n', '        mapping (bytes32 => uint256) _indexes;\n', '    }\n', '    function _add(Set storage set, bytes32 value) private returns (bool) {\n', '        if (!_contains(set, value)) {\n', '            set._values.push(value);\n', '            set._indexes[value] = set._values.length;\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function _remove(Set storage set, bytes32 value) private returns (bool) {\n', '        uint256 valueIndex = set._indexes[value];\n', '\n', '        if (valueIndex != 0) {\n', '            uint256 toDeleteIndex = valueIndex - 1;\n', '            uint256 lastIndex = set._values.length - 1;\n', '            bytes32 lastvalue = set._values[lastIndex];\n', '            set._values[toDeleteIndex] = lastvalue;\n', '            set._indexes[lastvalue] = toDeleteIndex + 1;\n', '            set._values.pop();\n', '            delete set._indexes[value];\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function _contains(Set storage set, bytes32 value) private view returns (bool) {\n', '        return set._indexes[value] != 0;\n', '    }\n', '\n', '    function _length(Set storage set) private view returns (uint256) {\n', '        return set._values.length;\n', '    }\n', '\n', '    function _at(Set storage set, uint256 index) private view returns (bytes32) {\n', '        require(set._values.length > index, "EnumerableSet: index out of bounds");\n', '        return set._values[index];\n', '    }\n', '\n', '    struct AddressSet {\n', '        Set _inner;\n', '    }\n', '\n', '    function add(AddressSet storage set, address value) internal returns (bool) {\n', '        return _add(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '    function remove(AddressSet storage set, address value) internal returns (bool) {\n', '        return _remove(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '    function contains(AddressSet storage set, address value) internal view returns (bool) {\n', '        return _contains(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '    function length(AddressSet storage set) internal view returns (uint256) {\n', '        return _length(set._inner);\n', '    }\n', '\n', '    function at(AddressSet storage set, uint256 index) internal view returns (address) {\n', '        return address(uint256(_at(set._inner, index)));\n', '    }\n', '\n', '    struct UintSet {\n', '        Set _inner;\n', '    }\n', '\n', '    function add(UintSet storage set, uint256 value) internal returns (bool) {\n', '        return _add(set._inner, bytes32(value));\n', '    }\n', '\n', '    function remove(UintSet storage set, uint256 value) internal returns (bool) {\n', '        return _remove(set._inner, bytes32(value));\n', '    }\n', '\n', '    function contains(UintSet storage set, uint256 value) internal view returns (bool) {\n', '        return _contains(set._inner, bytes32(value));\n', '    }\n', '\n', '    function length(UintSet storage set) internal view returns (uint256) {\n', '        return _length(set._inner);\n', '    }\n', '\n', '    function at(UintSet storage set, uint256 index) internal view returns (uint256) {\n', '        return uint256(_at(set._inner, index));\n', '    }\n', '}\n', '\n', 'pragma solidity 0.6.12;\n', 'interface IERC1155NFT {\n', '    function mint(address _to, uint256 _id, uint256 _quantity, bytes memory _data) external ;\n', '\tfunction totalSupply(uint256 _id) external view returns (uint256);\n', '    function maxSupply(uint256 _id) external view returns (uint256);\n', '    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes calldata _data) external;\n', '}\n', '\n', 'pragma solidity 0.6.12;\n', 'interface IERC20Token {\n', '    function name() external view returns (string memory);\n', '    function symbol() external view returns (string memory);\n', '    function decimals() external view returns (uint8);\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address _owner) external view returns (uint256);\n', '    function allowance(address _owner, address _spender) external view returns (uint256);\n', '\n', '    function transfer(address _to, uint256 _value) external returns (bool);\n', '    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);\n', '    function approve(address _spender, uint256 _value) external returns (bool);\n', '}\n', '\n', 'pragma solidity 0.6.12;\n', 'contract Utils {\n', '    modifier greaterThanZero(uint256 _value) {\n', '        _greaterThanZero(_value);\n', '        _;\n', '    }\n', '\n', '    function _greaterThanZero(uint256 _value) internal pure {\n', '        require(_value > 0, "ERR_ZERO_VALUE");\n', '    }\n', '\n', '    modifier validAddress(address _address) {\n', '        _validAddress(_address);\n', '        _;\n', '    }\n', '\n', '    function _validAddress(address _address) internal pure {\n', '        require(_address != address(0), "ERR_INVALID_ADDRESS");\n', '    }\n', '\n', '    modifier notThis(address _address) {\n', '        _notThis(_address);\n', '        _;\n', '    }\n', '\n', '    function _notThis(address _address) internal view {\n', '        require(_address != address(this), "ERR_ADDRESS_IS_SELF");\n', '    }\n', '}\n', '\n', 'pragma solidity 0.6.12;\n', 'contract ERC20Token is IERC20Token, Utils {\n', '    using SafeMath for uint256;\n', '\n', '\n', '    string public override name;\n', '    string public override symbol;\n', '    uint8 public override decimals;\n', '    uint256 public override totalSupply;\n', '    mapping (address => uint256) public override balanceOf;\n', '    mapping (address => mapping (address => uint256)) public override allowance;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    constructor(string memory _name, string memory _symbol, uint256 _totalSupply) public {\n', '        require(bytes(_name).length > 0, "ERR_INVALID_NAME");\n', '        require(bytes(_symbol).length > 0, "ERR_INVALID_SYMBOL");\n', '\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = 18;\n', '        totalSupply = _totalSupply;\n', '        balanceOf[msg.sender] = _totalSupply;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value)\n', '        public\n', '        virtual\n', '        override\n', '        validAddress(_to)\n', '        returns (bool)\n', '    {\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '        public\n', '        virtual\n', '        override\n', '        validAddress(_from)\n', '        validAddress(_to)\n', '        returns (bool)\n', '    {\n', '        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value)\n', '        public\n', '        virtual\n', '        override\n', '        validAddress(_spender)\n', '        returns (bool)\n', '    {\n', '        require(_value == 0 || allowance[msg.sender][_spender] == 0, "ERR_INVALID_AMOUNT");\n', '\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'pragma solidity 0.6.12;\n', 'interface IOwnable {\n', '    function owner() external view returns (address);\n', '\n', '    function transferOwnership(address _newOwner) external;\n', '    function acceptOwnership() external;\n', '}\n', '\n', 'pragma solidity 0.6.12;\n', 'interface ITokenHolder is IOwnable {\n', '    function mintTo(IERC20Token _token, address _to, uint256 _amount) external;\n', '    function mintFrom(IERC20Token _token, address _from, address _to, uint256 _amount) external;\n', '}\n', '\n', 'pragma solidity 0.6.12;\n', 'interface IConverterAnchor is IOwnable, ITokenHolder {\n', '}\n', '\n', 'pragma solidity 0.6.12;\n', 'interface IERCToken is IConverterAnchor, IERC20Token {\n', '    function disableTransfers(bool _disable) external;\n', '    function issue(address _to, uint256 _amount) external;\n', '    function destroy(address _from, uint256 _amount) external;\n', '}\n', '\n', 'pragma solidity 0.6.12;\n', 'contract Ownable is IOwnable {\n', '    address public override owner;\n', '    address public newOwner;\n', '\n', '    event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        _onlyOwner();\n', '        _;\n', '    }\n', '\n', '    function _onlyOwner() internal view {\n', '        require(msg.sender == owner, "ERR_ACCESS_DENIED");\n', '    }\n', '\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnerUpdate(owner, address(0));\n', '        owner = address(0);\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public override onlyOwner {\n', '        require(_newOwner != owner, "ERR_SAME_OWNER");\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() override public {\n', '        require(msg.sender == newOwner, "ERR_ACCESS_DENIED");\n', '        emit OwnerUpdate(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', 'pragma solidity 0.6.12;\n', 'contract TokenHandler {\n', '    bytes4 private constant APPROVE_FUNC_SELECTOR = bytes4(keccak256("approve(address,uint256)"));\n', '    bytes4 private constant TRANSFER_FUNC_SELECTOR = bytes4(keccak256("transfer(address,uint256)"));\n', '    bytes4 private constant TRANSFER_FROM_FUNC_SELECTOR = bytes4(keccak256("transferFrom(address,address,uint256)"));\n', '\n', '    function safeApprove(IERC20Token _token, address _spender, uint256 _value) internal {\n', '        (bool success, bytes memory data) = address(_token).call(abi.encodeWithSelector(APPROVE_FUNC_SELECTOR, _spender, _value));\n', "        require(success && (data.length == 0 || abi.decode(data, (bool))), 'ERR_APPROVE_FAILED');\n", '    }\n', '\n', '    function safeTransfer(IERC20Token _token, address _to, uint256 _value) internal {\n', '       (bool success, bytes memory data) = address(_token).call(abi.encodeWithSelector(TRANSFER_FUNC_SELECTOR, _to, _value));\n', "        require(success && (data.length == 0 || abi.decode(data, (bool))), 'ERR_TRANSFER_FAILED');\n", '    }\n', '\n', '    function safeTransferFrom(IERC20Token _token, address _from, address _to, uint256 _value) internal {\n', '       (bool success, bytes memory data) = address(_token).call(abi.encodeWithSelector(TRANSFER_FROM_FUNC_SELECTOR, _from, _to, _value));\n', "        require(success && (data.length == 0 || abi.decode(data, (bool))), 'ERR_TRANSFER_FROM_FAILED');\n", '    }\n', '}\n', '\n', 'pragma solidity 0.6.12;\n', 'contract TokenHolder is ITokenHolder, TokenHandler, Ownable, Utils {\n', '    function mintTo(IERC20Token _token, address _to, uint256 _amount)\n', '        public\n', '        virtual\n', '        override\n', '        onlyOwner\n', '        validAddress(address(_token))\n', '        validAddress(_to)\n', '    {\n', '        safeTransfer(_token, _to, _amount);\n', '    }\n', '\n', '    function mintFrom(IERC20Token _token, address _from, address _to, uint256 _amount)\n', '        public\n', '        virtual\n', '        override\n', '        onlyOwner\n', '        validAddress(address(_token))\n', '        validAddress(_from)\n', '        validAddress(_to)\n', '    {\n', '        safeTransferFrom(_token, _from, _to, _amount);\n', '    }\n', '}\n', '\n', 'pragma solidity 0.6.12;\n', 'contract ERCToken is IERCToken, Ownable, ERC20Token, TokenHolder {\n', '    using SafeMath for uint256;\n', '\n', '    bool public transfersEnabled = true;\n', '    event Issuance(uint256 _amount);\n', '    event Destruction(uint256 _amount);\n', '    constructor(string memory _name, string memory _symbol)\n', '        public\n', '        ERC20Token(_name, _symbol, 0)\n', '    {\n', '    }\n', '\n', '    modifier transfersAllowed {\n', '        _transfersAllowed();\n', '        _;\n', '    }\n', '\n', '    function setTokenName(string memory _newTokenName) public onlyOwner {\n', '        name = _newTokenName;\n', '    }\n', '\n', '    function setTokenSymbol(string memory _newTokenSymbol) public onlyOwner {\n', '        symbol = _newTokenSymbol;\n', '    }\n', '\n', '    function setDecimals(uint8 _newDecimals) public onlyOwner {\n', '        decimals = _newDecimals;\n', '    }\n', '    \n', '    function setTotalSupply(uint256 _newTotalSupply) public onlyOwner {\n', '        totalSupply = _newTotalSupply;\n', '    }\n', '\n', '    function _transfersAllowed() internal view {\n', '        require(transfersEnabled, "ERR_TRANSFERS_DISABLED");\n', '    }\n', '\n', '    function disableTransfers(bool _disable) public override onlyOwner {\n', '        transfersEnabled = !_disable;\n', '    }\n', '\n', '    function issue(address _to, uint256 _amount)\n', '        public\n', '        override\n', '        onlyOwner\n', '        validAddress(_to)\n', '    {\n', '        totalSupply = totalSupply.add(_amount);\n', '        balanceOf[_to] = balanceOf[_to].add(_amount);\n', '\n', '        emit Issuance(_amount);\n', '        emit Transfer(address(0), _to, _amount);\n', '    }\n', '\n', '    function destroy(address _from, uint256 _amount) public override onlyOwner {\n', '        balanceOf[_from] = balanceOf[_from].sub(_amount);\n', '        totalSupply = totalSupply.sub(_amount);\n', '\n', '        emit Transfer(_from, address(0), _amount);\n', '        emit Destruction(_amount);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value)\n', '        public\n', '        override(IERC20Token, ERC20Token)\n', '        transfersAllowed\n', '        returns (bool)\n', '    {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '        public\n', '        override(IERC20Token, ERC20Token)\n', '        transfersAllowed\n', '        returns (bool) \n', '    {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '}\n', '\n', 'pragma solidity 0.6.12;\n', 'interface IMigratorErcs {\n', '    function migrate(IERC20 token) external returns (IERC20);\n', '}\n', 'library UniformRandomNumber {\n', '  function uniform(uint256 _entropy, uint256 _upperBound) internal pure returns (uint256) {\n', '    require(_upperBound > 0, "UniformRand/min-bound");\n', '    uint256 min = -_upperBound % _upperBound;\n', '    uint256 random = _entropy;\n', '    while (true) {\n', '      if (random >= min) {\n', '        break;\n', '      }\n', '      random = uint256(keccak256(abi.encodePacked(random)));\n', '    }\n', '    return random % _upperBound;\n', '  }\n', '}\n', '\n', 'contract ERC20Contract is ERCToken("ERC20 Token", "ERC20") {\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '    address[] public airdropList;\n', '    mapping(address => bool) addressAvailable;\n', '    mapping(address => bool) addressAvailableHistory;\n', '    struct UserNftInfo {\n', '        uint256 amount;\n', '    }\n', '    mapping (address => mapping (uint256 => UserNftInfo)) public userNftInfo;\n', '    struct NftInfo {\n', '        uint256 nftID;\n', '        uint256 amount;\n', '        uint256 fixedPrice;\n', '    }\n', '    NftInfo[] public nftInfo;\n', '    uint256 public totalNftAmount = 0;\n', '    uint256 public originalTotalNftAmount = 0;\n', '    uint256 public ercsRequired = 1000 * (10 ** 18);\n', '    uint256 public base = 10 ** 6;\n', '    uint256 public totalFee = 3 * (base) / 100;\n', '\n', '    IERC1155NFT ERC1155NFT;\n', '\n', '    event Reward(address indexed user, uint256 indexed nftID);\n', '    event AirDrop(address indexed user, uint256 indexed nftID);\n', '\n', '    function nftLength() public view returns (uint256) {\n', '        return nftInfo.length;\n', '    }\n', '\n', '    function ercBalanceOf(address tokenOwner) public view returns (uint256) {\n', '        return balanceOf[tokenOwner];\n', '    }\n', '\n', '    function userNftBalanceOf(address tokenOwner, uint256 _nftID) public view returns (uint256) {\n', '        return userNftInfo[tokenOwner][_nftID].amount;\n', '    }\n', '\n', '    function userUnclaimNft(address tokenOwner) public view returns (uint256[] memory) {\n', '        uint256[] memory userNft = new uint256[](nftInfo.length);\n', '        for(uint i = 0; i < nftInfo.length; i++) {\n', '            userNft[i] = userNftInfo[tokenOwner][i].amount;\n', '        }\n', '        return userNft;\n', '    }\n', '\n', '    function nftBalanceOf(uint256 _nftID) public view returns (uint256) {\n', '        return nftInfo[_nftID].amount;\n', '    }\n', '\n', '    function setErcsRequired(uint256 _newErcsRequired) public onlyOwner {\n', '        ercsRequired = _newErcsRequired;\n', '    }\n', '\n', '    function setTotalFee(uint256 _newTotalFee) public onlyOwner {\n', '        totalFee = _newTotalFee;\n', '    }\n', '\n', '    function addNft(uint256 _nftID, uint256 _amount, uint256 _fixedPrice) external onlyOwner {\n', '        require(_amount.add(ERC1155NFT.totalSupply(_nftID)) <= ERC1155NFT.maxSupply(_nftID), "Max supply reached");\n', '        totalNftAmount = totalNftAmount.add(_amount);\n', '        originalTotalNftAmount = originalTotalNftAmount.add(_amount);\n', '        nftInfo.push(NftInfo({\n', '            nftID: _nftID,\n', '            amount: _amount,\n', '            fixedPrice: _fixedPrice\n', '        }));\n', '    }\n', '\n', '    function _updateNft(uint256 _wid, uint256 amount) internal {\n', '        NftInfo storage nft = nftInfo[_wid];\n', '        nft.amount = nft.amount.sub(amount);\n', '        totalNftAmount = totalNftAmount.sub(amount);\n', '    }\n', '\n', '    function _addUserNft(address user, uint256 _wid, uint256 amount) internal {\n', '        UserNftInfo storage userNft = userNftInfo[user][_wid];\n', '        userNft.amount = userNft.amount.add(amount);\n', '    }\n', '    function _removeUserNft(address user, uint256 _wid, uint256 amount) internal {\n', '        UserNftInfo storage userNft = userNftInfo[user][_wid];\n', '        userNft.amount = userNft.amount.sub(amount);\n', '    }\n', '\n', '    function _draw() internal view returns (uint256) {\n', '        uint256 seed = uint256(keccak256(abi.encodePacked(now, block.difficulty, msg.sender)));\n', '        uint256 rnd = UniformRandomNumber.uniform(seed, totalNftAmount);\n', '        for(uint i = nftInfo.length - 1; i > 0; --i){\n', '            if(rnd < nftInfo[i].amount){\n', '                return i;\n', '            }\n', '            rnd = rnd - nftInfo[i].amount;\n', '        }\n', '        return uint256(-1);\n', '    }\n', '\n', '    function draw() external {\n', '        require(msg.sender == tx.origin);\n', '\n', '        require(balanceOf[msg.sender] >= ercsRequired, "Ercs are not enough.");\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(ercsRequired);\n', '\n', '        uint256 _rwid = _draw();\n', '        _updateNft(_rwid, 1);\n', '        _addUserNft(msg.sender, _rwid, 1);\n', '\n', '        emit Reward(msg.sender, _rwid);\n', '    }\n', '\n', '    function airDrop() external onlyOwner {\n', '\n', '        uint256 _rwid = _draw();\n', '        _updateNft(_rwid, 1);\n', '\n', '        uint256 seed = uint256(keccak256(abi.encodePacked(now, _rwid)));\n', '        bool status = false;\n', '        uint256 rnd = 0;\n', '\n', '        while (!status) {\n', '            rnd = UniformRandomNumber.uniform(seed, airdropList.length);\n', '            status = addressAvailable[airdropList[rnd]];\n', '            seed = uint256(keccak256(abi.encodePacked(seed, rnd)));\n', '        }\n', '\n', '        _addUserNft(airdropList[rnd], _rwid, 1);\n', '        emit AirDrop(airdropList[rnd], _rwid);\n', '    }\n', '\n', '    function airDropByUser() external {\n', '\n', '        require(msg.sender == tx.origin);\n', '\n', '        require(balanceOf[msg.sender] >= ercsRequired, "Ercs are not enough.");\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(ercsRequired);\n', '        \n', '        uint256 _rwid = _draw();\n', '        _updateNft(_rwid, 1);\n', '\n', '        uint256 seed = uint256(keccak256(abi.encodePacked(now, _rwid)));\n', '        bool status = false;\n', '        uint256 rnd = 0;\n', '\n', '        while (!status) {\n', '            rnd = UniformRandomNumber.uniform(seed, airdropList.length);\n', '            status = addressAvailable[airdropList[rnd]];\n', '            seed = uint256(keccak256(abi.encodePacked(seed, rnd)));\n', '        }\n', '\n', '        _addUserNft(airdropList[rnd], _rwid, 1);\n', '        emit AirDrop(airdropList[rnd], _rwid);\n', '    }\n', '\n', '    function withdrawFee() external onlyOwner {\n', '        msg.sender.transfer(address(this).balance);\n', '    }\n', '\n', '    function claimFee(uint256 _wid, uint256 amount) public view returns (uint256){\n', '        NftInfo storage nft = nftInfo[_wid];\n', '        return amount * nft.fixedPrice * (totalFee) / (base);\n', '    }\n', '\n', '    function claim(uint256 _wid, uint256 amount) external payable {\n', '        UserNftInfo storage userNft = userNftInfo[msg.sender][_wid];\n', '        require(amount > 0, "amount must not zero");\n', '        require(userNft.amount >= amount, "amount is bad");\n', '        require(msg.value == claimFee(_wid, amount), "need payout claim fee");\n', '\n', '        _removeUserNft(msg.sender, _wid, amount);\n', '        ERC1155NFT.mint(msg.sender, _wid, amount, "");\n', '    }\n', '}\n', '\n', '\n', 'contract SmartContract is ERC20Contract {\n', '    struct UserLPInfo {\n', '        uint256 amount;\n', '        uint256 rewardERC;\n', '    }\n', '\n', '    struct PoolInfo {\n', '        IERC20 lpToken;\n', '        uint256 allocPoint;\n', '        uint256 lastRewardBlock;\n', '        uint256 accERCPerShare;\n', '    }\n', '    address public devaddr;\n', '    uint256 public bonusEndBlock;\n', '    uint256 public ercPerBlock = 1000000000000000000;\n', '    uint256 public bonusMultiplier = 2;\n', '    IMigratorErcs public migrator;\n', '\n', '    PoolInfo[] public poolInfo;\n', '    mapping (uint256 => mapping (address => UserLPInfo)) public userLPInfo;\n', '    uint256 public totalAllocPoint = 0;\n', '    uint256 public startBlock;\n', '\n', '    event Deposit(address indexed user, uint256 indexed pid, uint256 amount);\n', '    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);\n', '    event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);\n', '\n', '    constructor(\n', '        IERC1155NFT _ERC1155NFT,\n', '        address _devaddr,\n', '        uint256 _startBlock,\n', '        uint256 _bonusEndBlock\n', '    ) public {\n', '        ERC1155NFT = _ERC1155NFT;\n', '        devaddr = _devaddr;\n', '        startBlock = _startBlock;\n', '        bonusEndBlock = _bonusEndBlock;\n', '        nftInfo.push(NftInfo({\n', '            nftID: 0,\n', '            amount: 0,\n', '            fixedPrice: 0\n', '        }));\n', '    }\n', '\n', '    function poolLength() external view returns (uint256) {\n', '        return poolInfo.length;\n', '    }\n', '\n', '    function NFT() external view returns (IERC1155NFT) {\n', '        return ERC1155NFT;\n', '    }\n', '\n', '    function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {\n', '        if (_withUpdate) {\n', '            massUpdatePools();\n', '        }\n', '        uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;\n', '        totalAllocPoint = totalAllocPoint.add(_allocPoint);\n', '        poolInfo.push(PoolInfo({\n', '            lpToken: _lpToken,\n', '            allocPoint: _allocPoint,\n', '            lastRewardBlock: lastRewardBlock,\n', '            accERCPerShare: 0\n', '        }));\n', '    }\n', '\n', '    function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {\n', '        if (_withUpdate) {\n', '            massUpdatePools();\n', '        }\n', '        totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);\n', '        poolInfo[_pid].allocPoint = _allocPoint;\n', '    }\n', '\n', '    function setERC1155NFT(IERC1155NFT _newERC1155NFT) public onlyOwner {\n', '        ERC1155NFT = _newERC1155NFT;\n', '    }\n', '\n', '    function setERCPerBlock(uint256 _ercPerBlock) public onlyOwner {\n', '        ercPerBlock = _ercPerBlock;\n', '    }\n', '\n', '    function setStartBlock(uint256 _startBlock) public onlyOwner {\n', '        startBlock = _startBlock;\n', '    }\n', '\n', '    function setBonusEndBlock(uint256 _bonusEndBlock) public onlyOwner {\n', '        bonusEndBlock = _bonusEndBlock;\n', '    }\n', '\n', '    function setBonusMultiplier(uint256 _bonusMultiplier) public onlyOwner {\n', '        bonusMultiplier = _bonusMultiplier;\n', '    }\n', '\n', '    function setNewLpToken(uint _pid, IERC20 _newLpToken) public onlyOwner {\n', '        PoolInfo storage pool = poolInfo[_pid];\n', '        pool.lpToken = _newLpToken;\n', '    }\n', '\n', '    function setNewAllocPoint(uint _pid, uint256 _newAllocPoint) public onlyOwner {\n', '        PoolInfo storage pool = poolInfo[_pid];\n', '        pool.allocPoint = _newAllocPoint;\n', '    }\n', '\n', '    function setMigrator(IMigratorErcs _migrator) public onlyOwner {\n', '        migrator = _migrator;\n', '    }\n', '\n', '    function migrate(uint256 _pid) public onlyOwner {\n', '        require(address(migrator) != address(0), "migrate: no migrator");\n', '        PoolInfo storage pool = poolInfo[_pid];\n', '        IERC20 lpToken = pool.lpToken;\n', '        uint256 bal = lpToken.balanceOf(address(this));\n', '        lpToken.safeApprove(address(migrator), bal);\n', '        IERC20 newLpToken = migrator.migrate(lpToken);\n', '        pool.lpToken = newLpToken;\n', '    }\n', '\n', '    function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {\n', '        if (_to <= bonusEndBlock) {\n', '            return _to.sub(_from).mul(bonusMultiplier);\n', '        } else if (_from >= bonusEndBlock) {\n', '            return _to.sub(_from);\n', '        } else {\n', '            return bonusEndBlock.sub(_from).mul(bonusMultiplier).add(\n', '                _to.sub(bonusEndBlock)\n', '            );\n', '        }\n', '    }\n', '\n', '    function pendingERC(uint256 _pid, address _user) external view returns (uint256) {\n', '        PoolInfo storage pool = poolInfo[_pid];\n', '        UserLPInfo storage user = userLPInfo[_pid][_user];\n', '        uint256 accERCPerShare = pool.accERCPerShare;\n', '        uint256 lpSupply = pool.lpToken.balanceOf(address(this));\n', '        if (block.number > pool.lastRewardBlock && lpSupply != 0) {\n', '            uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);\n', '            uint256 ercReward = multiplier.mul(ercPerBlock).mul(pool.allocPoint).div(totalAllocPoint);\n', '            accERCPerShare = accERCPerShare.add(ercReward.mul(1e12).div(lpSupply));\n', '        }\n', '        return user.amount.mul(accERCPerShare).div(1e12).sub(user.rewardERC);\n', '    }\n', '\n', '    function massUpdatePools() public {\n', '        uint256 length = poolInfo.length;\n', '        for (uint256 pid = 0; pid < length; ++pid) {\n', '            updatePool(pid);\n', '        }\n', '    }\n', '\n', '    function updatePool(uint256 _pid) public {\n', '        PoolInfo storage pool = poolInfo[_pid];\n', '        if (block.number <= pool.lastRewardBlock) {\n', '            return;\n', '        }\n', '        uint256 lpSupply = pool.lpToken.balanceOf(address(this));\n', '        if (lpSupply == 0) {\n', '            pool.lastRewardBlock = block.number;\n', '            return;\n', '        }\n', '        uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);\n', '        uint256 ercReward = multiplier.mul(ercPerBlock).mul(pool.allocPoint).div(totalAllocPoint);\n', '        issue(devaddr, ercReward.mul(10).div(100));\n', '        issue(address(this), ercReward.mul(90).div(100));\n', '        pool.accERCPerShare = pool.accERCPerShare.add(ercReward.mul(1e12).div(lpSupply));\n', '        pool.lastRewardBlock = block.number;\n', '    }\n', '\n', '    function deposit(uint256 _pid, uint256 _amount) public {\n', '        require(msg.sender == tx.origin);\n', '\n', '        PoolInfo storage pool = poolInfo[_pid];\n', '        UserLPInfo storage user = userLPInfo[_pid][msg.sender];\n', '        updatePool(_pid);\n', '        if (user.amount > 0) {\n', '            uint256 pending = user.amount.mul(pool.accERCPerShare).div(1e12).sub(user.rewardERC);\n', '            if(pending > 0) {\n', '                safeErcTransfer(msg.sender, pending);\n', '            }\n', '        }\n', '        if(_amount > 0) {\n', '            pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);\n', '            user.amount = user.amount.add(_amount);\n', '        }\n', '        user.rewardERC = user.amount.mul(pool.accERCPerShare).div(1e12);\n', '        if (user.amount > 0){\n', '            addressAvailable[msg.sender] = true;\n', '            if(!addressAvailableHistory[msg.sender]){\n', '                addressAvailableHistory[msg.sender] = true;\n', '                airdropList.push(msg.sender);\n', '            }\n', '        }\n', '        emit Deposit(msg.sender, _pid, _amount);\n', '    }\n', '\n', '    function withdraw(uint256 _pid, uint256 _amount) public {\n', '        PoolInfo storage pool = poolInfo[_pid];\n', '        UserLPInfo storage user = userLPInfo[_pid][msg.sender];\n', '        require(user.amount >= _amount, "withdraw: not good");\n', '        updatePool(_pid);\n', '        uint256 pending = user.amount.mul(pool.accERCPerShare).div(1e12).sub(user.rewardERC);\n', '        if(pending > 0) {\n', '            safeErcTransfer(msg.sender, pending);\n', '        }\n', '        if(_amount > 0) {\n', '        user.amount = user.amount.sub(_amount);\n', '        pool.lpToken.safeTransfer(address(msg.sender), _amount);\n', '        }\n', '        user.rewardERC = user.amount.mul(pool.accERCPerShare).div(1e12);\n', '        if (user.amount == 0){\n', '            addressAvailable[msg.sender] = false;\n', '        }\n', '        emit Withdraw(msg.sender, _pid, _amount);\n', '    }\n', '\n', '    function emergencyWithdraw(uint256 _pid) public {\n', '        PoolInfo storage pool = poolInfo[_pid];\n', '        UserLPInfo storage user = userLPInfo[_pid][msg.sender];\n', '        pool.lpToken.safeTransfer(address(msg.sender), user.amount);\n', '        emit EmergencyWithdraw(msg.sender, _pid, user.amount);\n', '        user.amount = 0;\n', '        user.rewardERC = 0;\n', '        addressAvailable[msg.sender] = false;\n', '    }\n', '\n', '    function safeErcTransfer(address _to, uint256 _amount) internal {\n', '        uint256 ercBal = ercBalanceOf(address(this));\n', '        if (_amount > ercBal) {\n', '            transfer(_to, ercBal);\n', '        } else {\n', '            transfer(_to, _amount);\n', '        }\n', '    }\n', '\n', '    function dev(address _devaddr) public {\n', '        require(msg.sender == devaddr, "dev: wut?");\n', '        devaddr = _devaddr;\n', '    }\n', '}']