['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', 'pragma experimental ABIEncoderV2;\n', '\n', "import './Ownable.sol';\n", "import './SafeMath.sol';\n", "import './Address.sol';\n", "import './Context.sol';\n", '\n', 'contract VRFRequestIDBase {\n', '    function makeVRFInputSeed(\n', '        bytes32 _keyHash,\n', '        uint256 _userSeed,\n', '        address _requester,\n', '        uint256 _nonce\n', '    ) internal pure returns (uint256) {\n', '        return  uint256(keccak256(abi.encode(_keyHash, _userSeed, _requester, _nonce)));\n', '    }\n', '    function makeRequestId(\n', '        bytes32 _keyHash,\n', '        uint256 _vRFInputSeed\n', '    ) internal pure returns (bytes32) {\n', '        return keccak256(abi.encodePacked(_keyHash, _vRFInputSeed));\n', '    }\n', '}\n', '\n', 'interface LinkTokenInterface {\n', '  function allowance(address owner, address spender) external view returns (uint256 remaining);\n', '  function approve(address spender, uint256 value) external returns (bool success);\n', '  function balanceOf(address owner) external view returns (uint256 balance);\n', '  function decimals() external view returns (uint8 decimalPlaces);\n', '  function decreaseApproval(address spender, uint256 addedValue) external returns (bool success);\n', '  function increaseApproval(address spender, uint256 subtractedValue) external;\n', '  function name() external view returns (string memory tokenName);\n', '  function symbol() external view returns (string memory tokenSymbol);\n', '  function totalSupply() external view returns (uint256 totalTokensIssued);\n', '  function transfer(address to, uint256 value) external returns (bool success);\n', '  function transferAndCall(address to, uint256 value, bytes calldata data) external returns (bool success);\n', '  function transferFrom(address from, address to, uint256 value) external returns (bool success);\n', '}\n', '\n', 'abstract contract VRFConsumerBase is VRFRequestIDBase {\n', '    using SafeMath for uint256;\n', '    \n', '    function fulfillRandomness(\n', '        bytes32 requestId,\n', '        uint256 randomness\n', '    ) internal virtual;\n', '\n', '    function requestRandomness(\n', '        bytes32 _keyHash,\n', '        uint256 _fee,\n', '        uint256 _seed\n', '    ) internal returns (bytes32 requestId) {\n', '        LINK.transferAndCall(vrfCoordinator, _fee, abi.encode(_keyHash, _seed));\n', '        uint256 vRFSeed  = makeVRFInputSeed(_keyHash, _seed, address(this), nonces[_keyHash]);\n', '        nonces[_keyHash] = nonces[_keyHash].add(1);\n', '        return makeRequestId(_keyHash, vRFSeed);\n', '    }\n', '\n', '    LinkTokenInterface immutable internal LINK;\n', '\n', '    address immutable private vrfCoordinator;\n', '    mapping(bytes32 /* keyHash */ => uint256 /* nonce */) private nonces;\n', '\n', '    constructor(\n', '        address _vrfCoordinator,\n', '        address _link\n', '    ) {\n', '        vrfCoordinator = _vrfCoordinator;\n', '        LINK = LinkTokenInterface(_link);\n', '    }\n', '\n', '    function rawFulfillRandomness(\n', '        bytes32 requestId,\n', '        uint256 randomness\n', '    ) external {\n', '        require(msg.sender == vrfCoordinator, "Only VRFCoordinator can fulfill");\n', '        fulfillRandomness(requestId, randomness);\n', '    }\n', '}\n', '\n', 'contract RandomNumberConsumer is VRFConsumerBase {\n', '    bytes32 internal keyHash;\n', '    uint256 internal fee;\n', '    \n', '    bool private progress = false;\n', '    uint256 private winner = 0;\n', '    address private distributer;\n', '    \n', '    modifier onlyDistributer() {\n', '        require(distributer == msg.sender, "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '    \n', '    /**\n', '     * Constructor inherits VRFConsumerBase\n', '     * \n', '     * Network: Mainnet\n', '     * Chainlink VRF Coordinator address: 0xf0d54349aDdcf704F77AE15b96510dEA15cb7952\n', '     * LINK token address:                0x514910771AF9Ca656af840dff83E8264EcF986CA\n', '     * Key Hash: 0xAA77729D3466CA35AE8D28B3BBAC7CC36A5031EFDC430821C02BC31A238AF445\n', '     */\n', '    constructor(address _distributer) \n', '        VRFConsumerBase(\n', '            0xf0d54349aDdcf704F77AE15b96510dEA15cb7952,\n', '            0x514910771AF9Ca656af840dff83E8264EcF986CA\n', '        )\n', '    {\n', '        keyHash = 0xAA77729D3466CA35AE8D28B3BBAC7CC36A5031EFDC430821C02BC31A238AF445;\n', '        fee = 2 * 10 ** 18; // 2 LINK\n', '        distributer = _distributer;\n', '    }\n', '    \n', '    /** \n', '     * Requests randomness from a user-provided seed\n', '     */\n', '    function getRandomNumber(uint256 userProvidedSeed) public onlyDistributer returns (bytes32 requestId) {        \n', '        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");\n', '        require(!progress, "now getting an random number.");\n', '        winner = 0;\n', '        progress = true;\n', '        return requestRandomness(keyHash, fee, userProvidedSeed);\n', '    }\n', '\n', '    /**\n', '     * Callback function used by VRF Coordinator\n', '     */\n', '    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {\n', '        requestId = 0;\n', '        progress = false;\n', '        winner = randomness;\n', '    }\n', '\n', '    function getWinner() external view onlyDistributer returns (uint256) {\n', '        if(progress)\n', '            return 0;\n', '        return winner;\n', '    }\n', '}\n', '\n', 'contract Distribution is Context, Ownable {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    RandomNumberConsumer public rnGenerator;\n', '\n', '    uint256 public _randomCallCount = 0;\n', '    uint256 public _prevRandomCallCount = 0;\n', '\n', '    uint256 public _punkWinner = 6500;\n', '    uint256[] public _legendaryMonsterWinners;\n', '    uint256[] public _ethWinners;\n', '    uint256[] public _zedWinners;\n', '    \n', '    constructor () {\n', '        rnGenerator = new RandomNumberConsumer(address(this));\n', '    }\n', '\n', '    function getRandomNumber() external onlyOwner {\n', '        rnGenerator.getRandomNumber(_randomCallCount);\n', '        _randomCallCount = _randomCallCount + 1;\n', '    }\n', '\n', '    // Function to distribute punk.\n', '    function setPunkWinner() external onlyOwner {\n', '        require(_prevRandomCallCount != _randomCallCount, "Please generate random number.");\n', "        require(rnGenerator.getWinner() != 0, 'Please wait until random number generated.');\n", "        require(_punkWinner == 6500, 'You already picked punk winner');\n", '\n', '        _prevRandomCallCount = _randomCallCount;\n', '        _punkWinner = rnGenerator.getWinner().mod(6400);\n', '    }\n', '\n', '    // Function to distribute legendary monster.\n', '    function setLegendaryMonsterWinner() external onlyOwner {\n', '        require(_prevRandomCallCount != _randomCallCount, "Please generate random number.");\n', "        require(rnGenerator.getWinner() != 0, 'Please wait until random number generated.');\n", '        \n', '        _prevRandomCallCount = _randomCallCount;\n', '        uint256 _tempWinner = rnGenerator.getWinner().mod(3884);\n', '        for(uint i=0; i<_legendaryMonsterWinners.length; i++ ) {\n', "            require(_legendaryMonsterWinners[i] != _tempWinner, 'Same winner already exists.');\n", '        }\n', '        _legendaryMonsterWinners.push(_tempWinner);\n', '    }\n', '\n', '    // Function to distribute eth.\n', '    function setETHWinner() external onlyOwner {\n', '        require(_prevRandomCallCount != _randomCallCount, "Please generate random number.");\n', "        require(rnGenerator.getWinner() != 0, 'Please wait until random number generated.');\n", '        \n', '        _prevRandomCallCount = _randomCallCount;\n', '        uint256 _tempWinner = rnGenerator.getWinner().mod(400) + 6000;\n', '        for(uint i=0; i<_ethWinners.length; i++ ) {\n', "            require(_ethWinners[i] != _tempWinner, 'Same winner already exists.');\n", '        }\n', '        _ethWinners.push(_tempWinner);\n', '    }\n', '\n', '    // Function to distribute zed.\n', '    function setZedWinner() external onlyOwner {\n', '        require(_prevRandomCallCount != _randomCallCount, "Please generate random number.");\n', "        require(rnGenerator.getWinner() != 0, 'Please wait until random number generated.');\n", '        \n', '        _prevRandomCallCount = _randomCallCount;\n', '        uint256 _tempWinner = rnGenerator.getWinner().mod(6400);\n', '        for(uint i=0; i<_zedWinners.length; i++ ) {\n', "            require(_zedWinners[i] != _tempWinner, 'Same winner already exists.');\n", '        }\n', '        _zedWinners.push(_tempWinner);\n', '    }\n', '}']