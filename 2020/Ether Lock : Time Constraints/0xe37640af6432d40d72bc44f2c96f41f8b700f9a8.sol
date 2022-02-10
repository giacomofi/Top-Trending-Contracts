['// SPDX-License-Identifier: MIT\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', 'contract Ethage {\n', '\n', '    struct User {\n', '        uint128 mtx3Block;\n', '        uint128 mtx6Block;\n', '        address parent;\n', '    }\n', '\n', '    uint128 public constant NO_OF_BLOCKS = 12;\n', '\n', '    mapping(address => User) public users;\n', '\n', '    mapping(uint256 => uint256) public blockPriceMtx3;\n', '    mapping(uint256 => uint256) public blockPriceMtx6;\n', '\n', '    address owner;\n', '    address ai;\n', '    uint public aiGasCode = 0.009 ether;\n', '\n', '    event Registration(address indexed user, address indexed referrer);\n', '    event Upgrade(address indexed user, uint256 matrix, uint256 blockLevel);\n', '\n', '    constructor(address ownerAddress, address a, address b, address c, address d, address e) public {\n', '\n', '        blockPriceMtx3[1] = 0.03 ether;\n', '        blockPriceMtx3[2] = 0.06 ether;\n', '        blockPriceMtx3[3] = 0.12 ether;\n', '        blockPriceMtx3[4] = 0.24 ether;\n', '        blockPriceMtx3[5] = 0.5 ether;\n', '        blockPriceMtx3[6] = 1.0 ether;\n', '        blockPriceMtx3[7] = 2.0 ether;\n', '        blockPriceMtx3[8] = 4.0 ether;\n', '        blockPriceMtx3[9] = 8.0 ether;\n', '        blockPriceMtx3[10] = 16.0 ether;\n', '        blockPriceMtx3[11] = 32.0 ether;\n', '        blockPriceMtx3[12] = 64.0 ether;\n', '\n', '        blockPriceMtx6[1] = 0.02 ether;\n', '        blockPriceMtx6[2] = 0.06 ether;\n', '        blockPriceMtx6[3] = 0.12 ether;\n', '        blockPriceMtx6[4] = 0.24 ether;\n', '        blockPriceMtx6[5] = 0.5 ether;\n', '        blockPriceMtx6[6] = 1.0 ether;\n', '        blockPriceMtx6[7] = 2.0 ether;\n', '        blockPriceMtx6[8] = 4.0 ether;\n', '        blockPriceMtx6[9] = 8.0 ether;\n', '        blockPriceMtx6[10] = 16.0 ether;\n', '        blockPriceMtx6[11] = 32.0 ether;\n', '        blockPriceMtx6[12] = 64.0 ether;\n', '\n', '\n', '        ai = msg.sender;\n', '        owner = ownerAddress;\n', '\n', '        User memory user = User({\n', '            mtx3Block : NO_OF_BLOCKS,\n', '            mtx6Block : NO_OF_BLOCKS,\n', '            parent : address(0)\n', '            });\n', '\n', '        users[ownerAddress] = user;\n', '\n', '        init(a, b, c, d, e);\n', '    }\n', '\n', '    function safeAdd(uint a, uint b) private pure returns (uint) {\n', '        uint c = a + b;\n', '        assert(c >= a && c >= b);\n', '        return c;\n', '    }\n', '\n', '    modifier onlyAiRelay {\n', '        require(\n', '            msg.sender == ai,\n', '            "Only Ai Relay can call this function."\n', '        );\n', '        _;\n', '    }\n', '\n', '    function isUserExists(address user) public view returns (bool) {\n', '        return (users[user].mtx3Block != 0);\n', '    }\n', '\n', '    function init(address a, address b, address c, address d, address e) private {\n', '        User memory userA = User({\n', '            mtx3Block : NO_OF_BLOCKS,\n', '            mtx6Block : NO_OF_BLOCKS,\n', '            parent : owner\n', '            });\n', '\n', '        users[a] = userA;\n', '\n', '        User memory userB = User({\n', '            mtx3Block : NO_OF_BLOCKS,\n', '            mtx6Block : NO_OF_BLOCKS,\n', '            parent : owner\n', '            });\n', '\n', '        users[b] = userB;\n', '\n', '        User memory userC = User({\n', '            mtx3Block : NO_OF_BLOCKS,\n', '            mtx6Block : NO_OF_BLOCKS,\n', '            parent : a\n', '            });\n', '\n', '        users[c] = userC;\n', '\n', '        User memory userD = User({\n', '            mtx3Block : NO_OF_BLOCKS,\n', '            mtx6Block : NO_OF_BLOCKS,\n', '            parent : a\n', '            });\n', '\n', '        users[d] = userD;\n', '\n', '        User memory userE = User({\n', '            mtx3Block : NO_OF_BLOCKS,\n', '            mtx6Block : NO_OF_BLOCKS,\n', '            parent : b\n', '            });\n', '\n', '        users[e] = userE;\n', '    }\n', '\n', '    function nextAvailableBlockMtx3(uint256 blockLevel) public view returns (bool){\n', '        uint256 nextAvailable = users[msg.sender].mtx3Block + 1;\n', '        return (nextAvailable == blockLevel);\n', '    }\n', '\n', '    function nextAvailableBlockMtx6(uint256 blockLevel) public view returns (bool){\n', '        uint256 nextAvailable = users[msg.sender].mtx6Block + 1;\n', '        return (nextAvailable == blockLevel);\n', '    }\n', '\n', '\n', '    function signUp(address referrerAddress) external payable {\n', '        require(msg.value == safeAdd(0.05 ether, aiGasCode), "sign up cost 0.05 + AI Price");\n', '        require(isUserExists(referrerAddress), "referrer not exists");\n', '        require(!isUserExists(msg.sender), "user exists");\n', '\n', '        User memory user = User({\n', '            mtx3Block : 1,\n', '            mtx6Block : 1,\n', '            parent : referrerAddress\n', '            });\n', '\n', '        users[msg.sender] = user;\n', '        emit Registration(msg.sender, referrerAddress);\n', '\n', '        if (!address(uint160(ai)).send(aiGasCode)) {\n', '            address(uint160(ai)).transfer(aiGasCode);\n', '        }\n', '\n', '    }\n', '\n', '    function purchaseMtx3(uint256 blockLevel) external payable {\n', '        require(isUserExists(msg.sender), "user is not exists. Sign Up first.");\n', '        require(msg.value == safeAdd(blockPriceMtx3[blockLevel], aiGasCode), "invalid price");\n', "        require(blockLevel > 1 && blockLevel <= NO_OF_BLOCKS, 'invalid block');\n", '        require(nextAvailableBlockMtx3(blockLevel), "invalid block");\n', '\n', '        users[msg.sender].mtx3Block++;\n', '        emit Upgrade(msg.sender, 1, blockLevel);\n', '\n', '        if (!address(uint160(ai)).send(aiGasCode)) {\n', '            address(uint160(ai)).transfer(aiGasCode);\n', '        }\n', '    }\n', '\n', '    function purchaseMtx6(uint256 blockLevel) external payable {\n', '        require(isUserExists(msg.sender), "user is not exists. Sign Up first.");\n', '        uint requiredPrice = safeAdd(blockPriceMtx6[blockLevel], aiGasCode);\n', '        require(msg.value == requiredPrice, "invalid price");\n', "        require(blockLevel > 1 && blockLevel <= NO_OF_BLOCKS, 'invalid block');\n", '        require(nextAvailableBlockMtx6(blockLevel), "invalid block");\n', '\n', '        users[msg.sender].mtx6Block++;\n', '        emit Upgrade(msg.sender, 2, blockLevel);\n', '\n', '        if (!address(uint160(ai)).send(aiGasCode)) {\n', '            address(uint160(ai)).transfer(aiGasCode);\n', '        }\n', '\n', '    }\n', '\n', '    function signUpDividend(address mtx3Receiver, address mtx6Receiver, uint8 nonce) public onlyAiRelay {\n', '        require(isUserExists(mtx3Receiver), "mtx3Receiver does not exist.");\n', '        require(isUserExists(mtx6Receiver), "mtx6Receiver does not exist.");\n', '        require(nonce > 0, "invalid nonce");\n', '        if (!address(uint160(mtx3Receiver)).send(blockPriceMtx3[1])) {\n', '            address(uint160(mtx3Receiver)).transfer(blockPriceMtx3[1]);\n', '        }\n', '\n', '        if (!address(uint160(mtx6Receiver)).send(blockPriceMtx6[1])) {\n', '            address(uint160(mtx6Receiver)).transfer(blockPriceMtx6[1]);\n', '        }\n', '    }\n', '\n', '\n', '    function dividend(address receiver, uint matrix, uint blockLevel, uint8 nonce) public onlyAiRelay {\n', '        require(isUserExists(receiver), "receiver does not exist.");\n', '        require(matrix == 1 || matrix == 2, "invalid matrix");\n', '        require(nonce > 0, "invalid nonce");\n', '        if (matrix == 1) {\n', '            sendDividendMtx3(receiver, blockLevel);\n', '        } else {\n', '            sendDividendMtx6(receiver, blockLevel);\n', '        }\n', '\n', '    }\n', '\n', '    function usersActiveX3Block(address userAddress, uint8 level) public view returns (bool) {\n', '        return users[userAddress].mtx3Block >= level;\n', '    }\n', '\n', '    function usersActiveX6Block(address userAddress, uint8 level) public view returns (bool) {\n', '        return users[userAddress].mtx6Block >= level;\n', '    }\n', '\n', '    function getUser(address userAddress) public view returns (uint128, uint128, address) {\n', '        return (users[userAddress].mtx3Block,\n', '        users[userAddress].mtx6Block,\n', '        users[userAddress].parent);\n', '    }\n', '\n', '    function sendDividendMtx3(address receiver, uint blockLevel) private {\n', '        if (!address(uint160(receiver)).send(blockPriceMtx3[blockLevel])) {\n', '            address(uint160(receiver)).transfer(blockPriceMtx3[blockLevel]);\n', '        }\n', '    }\n', '\n', '    function sendDividendMtx6(address receiver, uint blockLevel) private {\n', '        if (!address(uint160(receiver)).send(blockPriceMtx6[blockLevel])) {\n', '            address(uint160(receiver)).transfer(blockPriceMtx6[blockLevel]);\n', '        }\n', '    }\n', '\n', '    function updateAiGasCode(uint gas) public onlyAiRelay {\n', '        aiGasCode = gas;\n', '    }\n', '\n', '    function updateAiAggregator(address aiProvider) public onlyAiRelay {\n', '        ai = aiProvider;\n', '    }\n', '}']