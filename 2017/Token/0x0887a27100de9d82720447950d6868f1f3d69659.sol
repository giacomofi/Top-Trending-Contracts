['pragma solidity^0.4.8;\n', 'contract BlockApps_Certificate_of_Completion_SF1018 {\n', '    address public owner = msg.sender;\n', '    string certificate;\n', '    bool certIssued = false;\n', '    function publishGraduatingClass(string cert) {\n', '        if (msg.sender != owner || certIssued)\n', '            throw;\n', '        certIssued = true;\n', '        certificate = cert;\n', '    }\n', '    function showCertificate() constant returns (string) {\n', '        return certificate;\n', '    }\n', '}']