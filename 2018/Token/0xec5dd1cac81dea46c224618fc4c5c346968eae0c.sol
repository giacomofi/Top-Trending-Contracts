['pragma solidity ^0.4.18;\n', 'contract BlockmaticsGraduationCertificate_051918 {\n', '    address public owner = msg.sender;\n', '    string public certificate;\n', '    bool public certIssued = false;\n', '\n', '    function publishGraduatingClass (string cert) public {\n', '        assert (msg.sender == owner && !certIssued);\n', '\n', '        certIssued = true;\n', '        certificate = cert;\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', 'contract BlockmaticsGraduationCertificate_051918 {\n', '    address public owner = msg.sender;\n', '    string public certificate;\n', '    bool public certIssued = false;\n', '\n', '    function publishGraduatingClass (string cert) public {\n', '        assert (msg.sender == owner && !certIssued);\n', '\n', '        certIssued = true;\n', '        certificate = cert;\n', '    }\n', '}']
