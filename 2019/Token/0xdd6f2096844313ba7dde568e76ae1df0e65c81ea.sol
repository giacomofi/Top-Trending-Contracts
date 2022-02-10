['/**\n', ' *Submitted for verification at Etherscan.io on 2019-07-06\n', '*/\n', '\n', 'pragma solidity >=0.5.1 <0.6.0;\n', '\n', 'contract crossword_reward {\n', '    bytes32 solution_hash;\n', '    \n', '    // Contract constructor\n', '    constructor () public {\n', '        solution_hash = 0x2d64478620cf2836ecf1a6ef9ec90e5a540899939c5e411ae44656ddadc6081e;\n', '    }\n', '    \n', '    // Claim the reward\n', '    function claim(bytes20 solution, bytes32 salt) public {\n', '        require(keccak256(abi.encodePacked(solution, salt)) == solution_hash, "Mauvaise solution ou mauvais sel.");\n', '        msg.sender.transfer(address(this).balance);\n', '    }\n', '    \n', '    // Accept any incoming amount\n', '    function () external payable {}\n', '}']
['pragma solidity >=0.5.1 <0.6.0;\n', '\n', 'contract crossword_reward {\n', '    bytes32 solution_hash;\n', '    \n', '    // Contract constructor\n', '    constructor () public {\n', '        solution_hash = 0x2d64478620cf2836ecf1a6ef9ec90e5a540899939c5e411ae44656ddadc6081e;\n', '    }\n', '    \n', '    // Claim the reward\n', '    function claim(bytes20 solution, bytes32 salt) public {\n', '        require(keccak256(abi.encodePacked(solution, salt)) == solution_hash, "Mauvaise solution ou mauvais sel.");\n', '        msg.sender.transfer(address(this).balance);\n', '    }\n', '    \n', '    // Accept any incoming amount\n', '    function () external payable {}\n', '}']