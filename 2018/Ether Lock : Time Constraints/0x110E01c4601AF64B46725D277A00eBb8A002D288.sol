['pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' */\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract LoveBlocks {\n', '    using SafeMath for uint256;\n', '\n', '    event NewLoveBlock(string message, bool encrypted, uint timestamp);\n', '\n', '    struct LoveBlock {\n', '        string message;\n', '        bool encrypted;\n', '        uint timestamp;\n', '    }\n', '\n', '    LoveBlock[] public locks;\n', '\n', '    mapping (uint => address) private lockToOwner;\n', '    mapping (address => uint) private ownerToNumber;\n', '\n', '    function myLoveBlockCount() external view returns(uint) {\n', '        return ownerToNumber[msg.sender];\n', '    }\n', '\n', '    function totalLoveBlocks() external view returns(uint) {\n', '        return locks.length;\n', '    }\n', '\n', '    function createLoveBlock(string _message, bool _encrypted) external {\n', '        uint id = locks.push(LoveBlock(_message, _encrypted, now)) - 1;\n', '        lockToOwner[id] = msg.sender;\n', '        ownerToNumber[msg.sender] = ownerToNumber[msg.sender].add(1);\n', '        emit NewLoveBlock(_message, _encrypted, now);\n', '    }\n', '\n', '    function myLoveBlocks() external view returns(uint[]) {\n', '        uint[] memory result = new uint[](ownerToNumber[msg.sender]);\n', '\n', '        uint counter = 0;\n', '        for (uint i = 0; i < locks.length; i++) {\n', '            if (msg.sender == lockToOwner[i]) {\n', '                result[counter] = i;\n', '                counter = counter.add(1);\n', '            }\n', '        }\n', '        return result;\n', '    }\n', '}']