['pragma solidity 0.4.24;\n', '\n', 'contract EthmoFees {\n', '    uint FIWEthmoDeploy;\n', '    uint FIWEthmoMint;\n', '    address constant private Admin = 0x92Bf51aB8C48B93a96F8dde8dF07A1504aA393fD;\n', '    \n', '    \n', '    function FeeEthmoDeploy(uint FeeInWeiDeploy){\n', '    require(msg.sender==Admin);\n', '    if (msg.sender==Admin){\n', '        FIWEthmoDeploy=FeeInWeiDeploy;\n', '    }\n', '    }\n', '    \n', '    \n', '    function GetFeeEthmoDeploy()returns(uint){\n', '        return FIWEthmoDeploy;\n', '    }\n', '    \n', '    \n', '    function FeeEthmoMint(uint FeeInWeiMint){\n', '    require(msg.sender==Admin);\n', '    if (msg.sender==Admin){\n', '        FIWEthmoMint=FeeInWeiMint;\n', '    }\n', '    }\n', '    \n', '    function GetFeeEthmoMint()returns(uint){\n', '        return FIWEthmoMint;\n', '    }\n', '}']