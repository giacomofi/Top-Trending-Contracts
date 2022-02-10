['contract SFT {\n', '\n', '    string public name = "Smart First Time 4 Way GEE Distributor";\n', '    uint8 public decimals = 18;\n', '    string public symbol = "SFT";\n', '\n', '    address public dev = 0xC96CfB18C39DC02FBa229B6EA698b1AD5576DF4c;\n', '    address public foundation = 0x6eBe6E38ba1bDa9131C785f6491B2C8374B968fE;\n', '    address public management = 0x12CD0732249F4c14c7E11B397E28dEF3CF276251;\n', '    address public agency = 0xD02D2cDA1fA2250f809d6E9025e92d30AEd6C002;\n', '\n', '    function SFT() {\n', '\n', '    }\n', '\n', '    // automatically distribute incoming funds to the 4 addresses equally\n', '    function () payable public {\n', '        \n', '    }\n', '    \n', '    function withdrawFees() public {\n', '        uint256 share = (msg.value * 2500) / 10000; // split the incoming 4 ways\n', '        dev.transfer(share);\n', '        foundation.transfer(share);\n', '        management.transfer(share);\n', '        agency.transfer(share);\n', '    }\n', '\n', '    function changeDev (address _receiver) public\n', '    {\n', '        require(msg.sender == dev);\n', '        dev = _receiver;\n', '    }\n', '\n', '    function changeFoundation (address _receiver) public\n', '    {\n', '        require(msg.sender == foundation);\n', '        foundation = _receiver;\n', '    }\n', '\n', '    function changeManagement (address _receiver) public\n', '    {\n', '        require(msg.sender == management);\n', '        management = _receiver;\n', '    }\n', '\n', '    function changeAgency (address _receiver) public\n', '    {\n', '        require(msg.sender == agency);\n', '        agency = _receiver;\n', '    }\n', '\n', '    // just in case\n', '    function safeWithdrawal() public {\n', '        uint256 split = (this.balance * 2500) / 10000; // split the incoming 4 ways\n', '        dev.transfer(split);\n', '        foundation.transfer(split);\n', '        management.transfer(split);\n', '        agency.transfer(split);\n', '    }\n', '\n', '    function add(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        require(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function div(uint a, uint b) internal pure returns (uint) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '}']