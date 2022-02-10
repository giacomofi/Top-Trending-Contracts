['pragma solidity ^0.4.23;\n', '\n', '\n', '// Authorization control functions\n', 'contract Ownable {\n', '\t\n', '\t// The administrator of the contract\n', '\taddress private owner;\n', '\t\n', '\t// Set the owner to the original creator of the contract\n', '\tconstructor() public {\n', '\t\towner = msg.sender;\n', '\t}\n', '\t\n', '\t// Parameters like status can only be changed by the contract owner\n', '\tmodifier onlyOwner() {\n', '\t\trequire( \n', '\t\t\tmsg.sender == owner,\n', '\t\t\t&#39;Only the administrator can change this&#39;\n', '\t\t);\n', '\t\t_;\n', '\t}\n', '\t\n', '}\n', '\n', '\n', '// Primary contract\n', 'contract Blockchainedlove is Ownable {\n', '\t\n', '\t// Partner details and other contract parameters\n', '    string public partner_1_name;\n', '    string public partner_2_name;\n', '\tstring public contract_date;\n', '\tstring public declaration;\n', '\tbool public is_active;\n', '\t\n', '\t// Main function, executed once upon deployment\n', '\tconstructor() public {\n', '\t\t// Custom variables\n', '\t\tpartner_1_name = &#39;Avery&#39;;\n', '\t\tpartner_2_name = &#39;Jordan&#39;;\n', '\t\tcontract_date = &#39;11 January 2018&#39;;\n', '\t\t// Standard variables\n', '\t\tdeclaration = &#39;This smart contract has been prepared and deployed by Blockchained.Love - it is stored permanently on the Ethereum blockchain and cannot be deleted. The status of the smart contract, represented by the value of the is_active variable, an only be changed by Blockchained.Love following explicit consent from both persons mentioned in the document.&#39;;\n', '\t\tis_active = true;\n', '\t}\n', '\t\n', '\t// Change the status of the contract\n', '\tfunction updateStatus(bool _status) public onlyOwner {\n', '\t\tis_active = _status;\n', '\t\temit StatusChanged(is_active);\n', '\t}\n', '\t\n', '\t// Record the status change event\n', '\tevent StatusChanged(bool NewStatus);\n', '\t\n', '}']