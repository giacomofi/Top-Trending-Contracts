['pragma solidity ^0.4.25;\n', '\n', 'contract Sinocbot {\n', '\n', '    function batchTransfer(address _tokenAddress, address[] _receivers, uint256[] _values) public {\n', '\n', '        require(_receivers.length == _values.length && _receivers.length >= 1);\n', '        bytes4 methodId = bytes4(keccak256("transferFrom(address,address,uint256)"));\n', '        for(uint256 i = 0 ; i < _receivers.length; i++){\n', '            if(!_tokenAddress.call(methodId, msg.sender, _receivers[i], _values[i])) {\n', '                revert();\n', '            }\n', '        }\n', '    }\n', '}']
['pragma solidity ^0.4.25;\n', '\n', 'contract Sinocbot {\n', '\n', '    function batchTransfer(address _tokenAddress, address[] _receivers, uint256[] _values) public {\n', '\n', '        require(_receivers.length == _values.length && _receivers.length >= 1);\n', '        bytes4 methodId = bytes4(keccak256("transferFrom(address,address,uint256)"));\n', '        for(uint256 i = 0 ; i < _receivers.length; i++){\n', '            if(!_tokenAddress.call(methodId, msg.sender, _receivers[i], _values[i])) {\n', '                revert();\n', '            }\n', '        }\n', '    }\n', '}']