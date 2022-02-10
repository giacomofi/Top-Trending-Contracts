['pragma solidity ^0.5.0;\n', '\n', '//When the great leader arrives, he shall transfer $MAIZ from this contract to three LP pools.\n', '\n', 'interface MAIZ {\n', '    function owner() external view returns (address);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '}\n', '\n', 'interface MAIZLPPool {\n', '    function starttime() external view returns (uint256);\n', '    function yam()   external view returns (address);\n', '}\n', '\n', 'contract MAIZkeeper {\n', '    function transferToPool(address pool) public{\n', '        MAIZ maizetoken = MAIZ(0x9b42c461E4397D7880dAb88c8bB3D3cfC94b353A);\n', '        MAIZLPPool LPpool = MAIZLPPool(pool);\n', '        require (msg.sender == maizetoken.owner());\n', '        require (block.timestamp > 1599494400); //08/Sept/2020 00:00:00 (UTC+0) \n', '        require (LPpool.starttime() == 1599494400);\n', '        require (LPpool.yam() == 0x9b42c461E4397D7880dAb88c8bB3D3cfC94b353A);\n', '        maizetoken.transfer(pool, 5e22);\n', '    }\n', '}']