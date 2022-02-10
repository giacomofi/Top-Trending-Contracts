['pragma solidity ^0.4.23;\n', '\n', 'contract LoversForLife {\n', '    struct Lovers {\n', '        string lover1;\n', '        string lover2;\n', '        string whyDoYouLove;\n', '        uint worth;\n', '        \n', '        \n', '    }\n', '    \n', '    uint minPrice = 500000000000000;\n', '    uint maxPrice = 500000000000000000;\n', '    address creator;\n', '    Lovers[] public loverList;\n', '    uint public amountOfLovers = 0;\n', '    mapping(address => uint) loverNumber;\n', '\n', '    constructor() public {\n', '        creator = msg.sender;\n', '    }\n', '\n', '    function setPrice(uint price) public{\n', '        require(msg.sender == creator);\n', '        minPrice = price;\n', '    }\n', '    \n', '    function createLover(string l1, string l2, string message) public payable{\n', '        require(msg.value >= minPrice);\n', '        require(msg.value <= maxPrice);\n', '        Lovers memory newLover = Lovers ({\n', '            lover1: l1,\n', '            lover2: l2,\n', '            whyDoYouLove: message,\n', '            worth: msg.value\n', '            \n', '            \n', '        });\n', '        \n', '        loverList.push(newLover);\n', '        loverNumber[msg.sender] = amountOfLovers;\n', '        amountOfLovers++;\n', '       \n', '        creator.transfer(msg.value);\n', '    }\n', '    \n', '    function findLover(address user) public view returns (uint){\n', '        return loverNumber[user];\n', '    }\n', '    \n', '    \n', '    \n', '    \n', '}']