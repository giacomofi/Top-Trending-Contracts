['pragma solidity ^0.4.17;\n', '\n', 'contract Marriage {\n', '    struct Signage {\n', '        string name1;\n', '        string vow1;\n', '        string name2;\n', '        string vow2;\n', '    }\n', '\n', '    address public sealer;\n', '    string public sealedBy;\n', '    uint256 public numMarriages;\n', '\n', '    Signage[] signages;\n', '\n', '    function Marriage(string sealerName, address sealerAddress) public {\n', '        sealedBy = sealerName;\n', '        sealer = sealerAddress;\n', '    }\n', '\n', '    function sign(string vow1, string name1, string vow2, string name2) public {\n', '        require(msg.sender == sealer);\n', '\n', '        Signage memory signage = Signage(\n', '            vow1,\n', '            name1,\n', '            vow2,\n', '            name2\n', '        );\n', '        signages.push(signage);\n', '        numMarriages +=1 ;\n', '    }\n', '\n', '    function getMarriage(uint256 index)\n', '        public\n', '        constant returns (string, string, string, string)\n', '    {\n', '        return (signages[index].vow1, signages[index].name1, signages[index].vow2, signages[index].name2);\n', '    }\n', '}']
['pragma solidity ^0.4.17;\n', '\n', 'contract Marriage {\n', '    struct Signage {\n', '        string name1;\n', '        string vow1;\n', '        string name2;\n', '        string vow2;\n', '    }\n', '\n', '    address public sealer;\n', '    string public sealedBy;\n', '    uint256 public numMarriages;\n', '\n', '    Signage[] signages;\n', '\n', '    function Marriage(string sealerName, address sealerAddress) public {\n', '        sealedBy = sealerName;\n', '        sealer = sealerAddress;\n', '    }\n', '\n', '    function sign(string vow1, string name1, string vow2, string name2) public {\n', '        require(msg.sender == sealer);\n', '\n', '        Signage memory signage = Signage(\n', '            vow1,\n', '            name1,\n', '            vow2,\n', '            name2\n', '        );\n', '        signages.push(signage);\n', '        numMarriages +=1 ;\n', '    }\n', '\n', '    function getMarriage(uint256 index)\n', '        public\n', '        constant returns (string, string, string, string)\n', '    {\n', '        return (signages[index].vow1, signages[index].name1, signages[index].vow2, signages[index].name2);\n', '    }\n', '}']
