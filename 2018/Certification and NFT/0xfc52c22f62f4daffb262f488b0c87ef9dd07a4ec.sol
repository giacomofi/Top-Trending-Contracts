['pragma solidity ^0.4.24;\n', '\n', '\n', 'contract IAddressDeployerOwner {\n', '    function ownershipTransferred(address _byWhom) public returns(bool);\n', '}\n', '\n', '\n', 'contract AddressDeployer {\n', '    event Deployed(address at);\n', '\n', '    address public owner = msg.sender;\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        owner = _newOwner;\n', '    }\n', '\n', '    function transferOwnershipAndNotify(IAddressDeployerOwner _newOwner) public onlyOwner {\n', '        owner = _newOwner;\n', '        require(_newOwner.ownershipTransferred(msg.sender));\n', '    }\n', '\n', '    function deploy(bytes _data) public onlyOwner returns(address addr) {\n', '        // solium-disable-next-line security/no-inline-assembly\n', '        assembly {\n', '            addr := create(0, add(_data, 0x20), mload(_data))\n', '        }\n', '        require(addr != 0);\n', '        emit Deployed(addr);\n', '        //selfdestruct(msg.sender); // For some reason not works properly! Will fix in update!\n', '    }\n', '}']