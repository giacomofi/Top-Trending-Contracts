['// File: contracts/interfaces/IERC20.sol\n', '\n', 'pragma solidity ^0.5.17;\n', '\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '}\n', '\n', '// File: contracts/libraries/SafeMath.sol\n', '\n', 'pragma solidity ^0.5.17;\n', '\n', '\n', '// A library for performing overflow-safe math, courtesy of DappHub: https://github.com/dapphub/ds-math/blob/d0ef6d6a5f/src/math.sol\n', '// Modified to include only the essentials\n', 'library SafeMath {\n', '    function add(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '        require((z = x + y) >= x, "MATH:ADD_OVERFLOW");\n', '    }\n', '\n', '    function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '        require((z = x - y) <= x, "MATH:SUB_UNDERFLOW");\n', '    }\n', '}\n', '\n', '// File: contracts/ANTv2.sol\n', '\n', 'pragma solidity 0.5.17;\n', '\n', '\n', '\n', '\n', '// Lightweight token modelled after UNI-LP: https://github.com/Uniswap/uniswap-v2-core/blob/v1.0.1/contracts/UniswapV2ERC20.sol\n', '// Adds:\n', '//   - An exposed `mint()` with minting role\n', '//   - An exposed `burn()`\n', '//   - ERC-3009 (`transferWithAuthorization()`)\n', 'contract ANTv2 is IERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    string public constant name = "Aragon Network Token";\n', '    string public constant symbol = "ANT";\n', '    uint8 public constant decimals = 18;\n', '\n', '    // bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");\n', '    bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;\n', '    // bytes32 public constant TRANSFER_WITH_AUTHORIZATION_TYPEHASH =\n', '    //     keccak256("TransferWithAuthorization(address from,address to,uint256 value,uint256 validAfter,uint256 validBefore,bytes32 nonce)");\n', '    bytes32 public constant TRANSFER_WITH_AUTHORIZATION_TYPEHASH = 0x7c7c6cdb67a18743f49ec6fa9b35f50d52ed05cbed4cc592e13b44501c1a2267;\n', '\n', '    address public minter;\n', '    uint256 public totalSupply;\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    // ERC-712, ERC-2612, ERC-3009 state\n', '    bytes32 public DOMAIN_SEPARATOR;\n', '    mapping (address => uint256) public nonces;\n', '    mapping (address => mapping (bytes32 => bool)) public authorizationState;\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event AuthorizationUsed(address indexed authorizer, bytes32 indexed nonce);\n', '    event ChangeMinter(address indexed minter);\n', '\n', '    modifier onlyMinter {\n', '        require(msg.sender == minter, "ANTV2:NOT_MINTER");\n', '        _;\n', '    }\n', '\n', '    constructor(uint256 chainId, address initialMinter) public {\n', '        DOMAIN_SEPARATOR = keccak256(\n', '            abi.encode(\n', "                keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),\n", '                keccak256(bytes(name)),\n', "                keccak256(bytes('1')),\n", '                chainId,\n', '                address(this)\n', '            )\n', '        );\n', '\n', '        _changeMinter(initialMinter);\n', '    }\n', '\n', '    function _validateSignedData(address signer, bytes32 encodedData, uint8 v, bytes32 r, bytes32 s) internal view {\n', '        bytes32 digest = keccak256(\n', '            abi.encodePacked(\n', '                "\\x19\\x01",\n', '                DOMAIN_SEPARATOR,\n', '                encodedData\n', '            )\n', '        );\n', '        address recoveredAddress = ecrecover(digest, v, r, s);\n', '        // Explicitly disallow authorizations for address(0) as ecrecover returns address(0) on malformed messages\n', '        require(recoveredAddress != address(0) && recoveredAddress == signer, "ANTV2:INVALID_SIGNATURE");\n', '    }\n', '\n', '    function _changeMinter(address newMinter) internal {\n', '        minter = newMinter;\n', '        emit ChangeMinter(newMinter);\n', '    }\n', '\n', '    function _mint(address to, uint256 value) internal {\n', '        totalSupply = totalSupply.add(value);\n', '        balanceOf[to] = balanceOf[to].add(value);\n', '        emit Transfer(address(0), to, value);\n', '    }\n', '\n', '    function _burn(address from, uint value) internal {\n', "        // Balance is implicitly checked with SafeMath's underflow protection\n", '        balanceOf[from] = balanceOf[from].sub(value);\n', '        totalSupply = totalSupply.sub(value);\n', '        emit Transfer(from, address(0), value);\n', '    }\n', '\n', '    function _approve(address owner, address spender, uint256 value) private {\n', '        allowance[owner][spender] = value;\n', '        emit Approval(owner, spender, value);\n', '    }\n', '\n', '    function _transfer(address from, address to, uint256 value) private {\n', '        require(to != address(this), "ANTV2:RECEIVER_IS_TOKEN");\n', '\n', "        // Balance is implicitly checked with SafeMath's underflow protection\n", '        balanceOf[from] = balanceOf[from].sub(value);\n', '        balanceOf[to] = balanceOf[to].add(value);\n', '        emit Transfer(from, to, value);\n', '    }\n', '\n', '    function mint(address to, uint256 value) external onlyMinter returns (bool) {\n', '        _mint(to, value);\n', '        return true;\n', '    }\n', '\n', '    function changeMinter(address newMinter) external onlyMinter {\n', '        _changeMinter(newMinter);\n', '    }\n', '\n', '    function burn(uint256 value) external returns (bool) {\n', '        _burn(msg.sender, value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint256 value) external returns (bool) {\n', '        _approve(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    function transfer(address to, uint256 value) external returns (bool) {\n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool) {\n', '        uint256 fromAllowance = allowance[from][msg.sender];\n', '        if (fromAllowance != uint256(-1)) {\n', "            // Allowance is implicitly checked with SafeMath's underflow protection\n", '            allowance[from][msg.sender] = fromAllowance.sub(value);\n', '        }\n', '        _transfer(from, to, value);\n', '        return true;\n', '    }\n', '\n', '    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external {\n', '        require(deadline >= block.timestamp, "ANTV2:AUTH_EXPIRED");\n', '\n', '        bytes32 encodedData = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline));\n', '        _validateSignedData(owner, encodedData, v, r, s);\n', '\n', '        _approve(owner, spender, value);\n', '    }\n', '\n', '    function transferWithAuthorization(\n', '        address from,\n', '        address to,\n', '        uint256 value,\n', '        uint256 validAfter,\n', '        uint256 validBefore,\n', '        bytes32 nonce,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    )\n', '        external\n', '    {\n', '        require(block.timestamp > validAfter, "ANTV2:AUTH_NOT_YET_VALID");\n', '        require(block.timestamp < validBefore, "ANTV2:AUTH_EXPIRED");\n', '        require(!authorizationState[from][nonce],  "ANTV2:AUTH_ALREADY_USED");\n', '\n', '        bytes32 encodedData = keccak256(abi.encode(TRANSFER_WITH_AUTHORIZATION_TYPEHASH, from, to, value, validAfter, validBefore, nonce));\n', '        _validateSignedData(from, encodedData, v, r, s);\n', '\n', '        authorizationState[from][nonce] = true;\n', '        emit AuthorizationUsed(from, nonce);\n', '\n', '        _transfer(from, to, value);\n', '    }\n', '}']