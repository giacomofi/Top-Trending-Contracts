['pragma solidity ^0.7.0;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'interface InstaLMMerkleInterface {\n', '    function claim(\n', '        address recipient,\n', '        uint256 cumulativeAmount,\n', '        uint256 index,\n', '        uint256 cycle,\n', '        bytes32[] calldata merkleProof\n', '    ) external;\n', '}\n', '\n', 'contract Variables {\n', '    InstaLMMerkleInterface public immutable instaLMMerkle;\n', '\n', '    constructor(address _instaLMMerkle) {\n', '        instaLMMerkle = InstaLMMerkleInterface(_instaLMMerkle);\n', '    }\n', '}\n', '\n', 'contract Resolver is Variables {\n', '    constructor(address _instaLMMerkle) Variables(_instaLMMerkle) {}\n', '\n', '    event LogClaim(address user, uint256 index, uint256 cycle);\n', '\n', '\n', '    function claim (\n', '        uint256 index,\n', '        uint256 cumulativeAmount,\n', '        uint256 cycle,\n', '        bytes32[] calldata merkleProof\n', '    ) external payable returns (string memory _eventName, bytes memory _eventParam){\n', '        instaLMMerkle.claim(\n', '            address(this),\n', '            cumulativeAmount,\n', '            index,\n', '            cycle,\n', '            merkleProof\n', '        );\n', '\n', '        _eventName = "LogClaim(address,uint256,uint256)";\n', '        _eventParam = abi.encode(address(this), index, cycle);\n', '    }\n', '}\n', '\n', 'contract ConnectV2LMClaimer is Resolver {\n', '    constructor(address _instaLMMerkle) public Resolver(_instaLMMerkle) {}\n', '\n', '    string public constant name = "LM-Merkle-Claimer-v1.0";\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": false,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']