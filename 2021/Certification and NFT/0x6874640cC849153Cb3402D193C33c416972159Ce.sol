['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.8.0 <0.9.0;\n', '\n', "import './Migratable.sol';\n", '\n', 'contract Wormhole is Migratable {\n', '\n', '    event Freeze (\n', '        address indexed account,\n', '        uint256 amount,\n', '        uint256 fromChainId,\n', '        address fromWormhole,\n', '        uint256 toChainId,\n', '        address toWormhole,\n', '        uint256 nonce,\n', '        uint256 timestamp\n', '    );\n', '\n', '    event Claim (\n', '        address indexed account,\n', '        uint256 amount,\n', '        uint256 fromChainId,\n', '        address fromWormhole,\n', '        uint256 toChainId,\n', '        address toWormhole,\n', '        uint256 nonce,\n', '        uint256 timestamp\n', '    );\n', '\n', "    string public constant name = 'Wormhole';\n", '\n', '    address public tokenAddress;\n', '\n', '    bool public allowMintBurn;\n', '\n', '    uint256 public nonce;\n', '\n', '    uint256 public chainId;\n', '\n', '    mapping (bytes32 => bool) public usedHash;\n', '\n', "    bytes32 public constant DOMAIN_TYPEHASH = keccak256('EIP712Domain(string name,uint256 chainId,address verifyingContract)');\n", '\n', '    bytes32 public constant CLAIM_TYPEHASH = keccak256(\n', "        'Claim(address account,uint256 amount,uint256 fromChainId,address fromWormhole,uint256 toChainId,address toWormhole,uint256 nonce)'\n", '    );\n', '\n', '    constructor (address tokenAddress_, bool allowMintBurn_) {\n', '        controller = msg.sender;\n', '        tokenAddress = tokenAddress_;\n', '        allowMintBurn = allowMintBurn_;\n', '        uint256 _chainId;\n', '        assembly {\n', '            _chainId := chainid()\n', '        }\n', '        chainId = _chainId;\n', '    }\n', '\n', '    function approveMigration() public override _controller_ _valid_ {\n', "        require(migrationTimestamp != 0 && block.timestamp >= migrationTimestamp, 'Wormhole.approveMigration: migrationTimestamp not met yet');\n", '        if (allowMintBurn) {\n', '            IERC20(tokenAddress).setController(migrationDestination);\n', '        } else {\n', '            IERC20(tokenAddress).approve(migrationDestination, type(uint256).max);\n', '        }\n', '        isMigrated = true;\n', '\n', '        emit ApproveMigration(migrationTimestamp, address(this), migrationDestination);\n', '    }\n', '\n', '    function executeMigration(address source) public override _controller_ _valid_ {\n', '        uint256 _migrationTimestamp = IWormhole(source).migrationTimestamp();\n', '        address _migrationDestination = IWormhole(source).migrationDestination();\n', "        require(_migrationTimestamp != 0 && block.timestamp >= _migrationTimestamp, 'Wormhole.executeMigration: migrationTimestamp not met yet');\n", "        require(_migrationDestination == address(this), 'Wormhole.executeMigration: not destination address');\n", '\n', '        if (!IWormhole(source).allowMintBurn()) {\n', '            IERC20(tokenAddress).transferFrom(source, address(this), IERC20(tokenAddress).balanceOf(source));\n', '        }\n', '\n', '        emit ExecuteMigration(_migrationTimestamp, source, address(this));\n', '    }\n', '\n', '    function freeze(uint256 amount, uint256 toChainId, address toWormhole) public _valid_ {\n', "        require(amount > 0, 'Wormhole.freeze: 0 amount');\n", "        require(toChainId != chainId, 'Wormhole.freeze: to the same chain');\n", '        if (allowMintBurn) {\n', '            IERC20(tokenAddress).burn(msg.sender, amount);\n', '        } else {\n', '            IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount);\n', '        }\n', '        emit Freeze(msg.sender, amount, chainId, address(this), toChainId, toWormhole, nonce++, block.timestamp);\n', '    }\n', '\n', '    function claim(uint256 amount, uint256 fromChainId, address fromWormhole, uint256 fromNonce, uint8 v, bytes32 r, bytes32 s) public _valid_ {\n', '        bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), chainId, address(this)));\n', '        bytes32 structHash = keccak256(abi.encode(CLAIM_TYPEHASH, msg.sender, amount, fromChainId, fromWormhole, chainId, address(this), fromNonce));\n', "        require(!usedHash[structHash], 'Wormhole.claim: replay');\n", '        usedHash[structHash] = true;\n', '\n', "        bytes32 digest = keccak256(abi.encodePacked('\\x19\\x01', domainSeparator, structHash));\n", '        address signatory = ecrecover(digest, v, r, s);\n', "        require(signatory == controller, 'Wormhole.claim: unauthorized');\n", '\n', '        if (allowMintBurn) {\n', '            IERC20(tokenAddress).mint(msg.sender, amount);\n', '        } else {\n', '            IERC20(tokenAddress).transfer(msg.sender, amount);\n', '        }\n', '\n', '        emit Claim(msg.sender, amount, fromChainId, fromWormhole, chainId, address(this), fromNonce, block.timestamp);\n', '    }\n', '\n', '}\n', '\n', 'interface IERC20 {\n', '    function setController(address newController) external;\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function approve(address account, uint256 amount) external returns (bool);\n', '    function transfer(address to, uint256 amount) external returns (bool);\n', '    function transferFrom(address from, address to, uint256 amount) external returns (bool);\n', '    function mint(address account, uint256 amount) external;\n', '    function burn(address account, uint256 amount) external;\n', '}\n', '\n', 'interface IWormhole {\n', '    function migrationTimestamp() external view returns (uint256);\n', '    function migrationDestination() external view returns (address);\n', '    function allowMintBurn() external view returns (bool);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.8.0 <0.9.0;\n', '\n', 'abstract contract Migratable {\n', '\n', '    event PrepareMigration(uint256 migrationTimestamp, address source, address destination);\n', '\n', '    event ApproveMigration(uint256 migrationTimestamp, address source, address destination);\n', '\n', '    event ExecuteMigration(uint256 migrationTimestamp, address source, address destination);\n', '\n', '    address public controller;\n', '\n', '    uint256 public migrationTimestamp;\n', '\n', '    address public migrationDestination;\n', '\n', '    bool public isMigrated;\n', '\n', '    modifier _controller_() {\n', "        require(msg.sender == controller, 'Migratable._controller_: can only called by controller');\n", '        _;\n', '    }\n', '\n', '    modifier _valid_() {\n', "        require(!isMigrated, 'Migratable._valid_: cannot proceed, this contract has been migrated');\n", '        _;\n', '    }\n', '\n', '    function setController(address newController) public _controller_ _valid_ {\n', "        require(newController != address(0), 'Migratable.setController: to 0 address');\n", '        controller = newController;\n', '    }\n', '\n', '    function prepareMigration(address destination, uint256 graceDays) public _controller_ _valid_ {\n', "        require(destination != address(0), 'Migratable.prepareMigration: to 0 address');\n", "        require(graceDays >= 3 && graceDays <= 365, 'Migratable.prepareMigration: graceDays must be 3-365 days');\n", '\n', '        migrationTimestamp = block.timestamp + graceDays * 1 days;\n', '        migrationDestination = destination;\n', '\n', '        emit PrepareMigration(migrationTimestamp, address(this), migrationDestination);\n', '    }\n', '\n', '    function approveMigration() public virtual;\n', '\n', '    function executeMigration(address source) public virtual;\n', '\n', '}']