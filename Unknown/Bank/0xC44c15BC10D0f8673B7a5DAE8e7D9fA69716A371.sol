['pragma solidity ^0.4.11;\n', '\n', 'contract mortal\n', '{\n', '    address owner;\n', '\n', '    function mortal() { owner = msg.sender; }\n', '    function kill() { if(msg.sender == owner) selfdestruct(owner); }\n', '}\n', '\n', 'contract SandwichShop is mortal\n', '{\n', '\n', '    struct Sandwich\n', '    {\n', '        uint sandwichID;\n', '        string sandwichName;\n', '        string sandwichDesc;\n', '        string calories;\n', '        uint price;\n', '        uint availableQuantity;\n', '    }\n', '\n', '    struct OrderedSandwich\n', '    {\n', '        uint sandID;\n', '        string notes;\n', '        uint price;\n', '    }\n', '\n', '    Sandwich[5] shopSandwich;\n', '    mapping( address => OrderedSandwich[] ) public cart; \n', '\n', '    function SandwichShop() public\n', '    {\n', '        shopSandwich[0].sandwichID = 0;\n', '        shopSandwich[0].sandwichName = "100: Ham & Swiss";\n', '        shopSandwich[0].sandwichDesc = "Ham Swiss Mustard Rye";\n', '        shopSandwich[0].calories = "450 calories";\n', '        shopSandwich[0].price = 5;\n', '        shopSandwich[0].availableQuantity = 200;\n', '\n', '        shopSandwich[1].sandwichID = 1;\n', '        shopSandwich[1].sandwichName = "101: Turkey & Pepperjack";\n', '        shopSandwich[1].sandwichDesc = "Turkey Pepperjack Mayo White Bread";\n', '        shopSandwich[1].calories = "500 calories";\n', '        shopSandwich[1].price = 5;\n', '        shopSandwich[1].availableQuantity = 200;\n', '\n', '        shopSandwich[2].sandwichID = 2;\n', '        shopSandwich[2].sandwichName = "102: Roast Beef & American";\n', '        shopSandwich[2].sandwichDesc = "Roast Beef Havarti Horseradish White Bread";\n', '        shopSandwich[2].calories = "600 calories";\n', '        shopSandwich[2].price = 5;\n', '        shopSandwich[2].availableQuantity = 200;\n', '\n', '        shopSandwich[3].sandwichID = 3;\n', '        shopSandwich[3].sandwichName = "103: Reuben";\n', '        shopSandwich[3].sandwichDesc = "Corned Beef Sauerkraut Swiss Rye";\n', '        shopSandwich[3].calories = "550 calories";\n', '        shopSandwich[3].price = 5;\n', '        shopSandwich[3].availableQuantity = 200;\n', '\n', '        shopSandwich[4].sandwichID = 4;\n', '        shopSandwich[4].sandwichName = "104: Italian";\n', '        shopSandwich[4].sandwichDesc = "Salami Peppers Provolone Oil Vinegar White";\n', '        shopSandwich[4].calories = "500 calories";\n', '        shopSandwich[4].price = 5;\n', '        shopSandwich[4].availableQuantity = 200;\n', '    }\n', '\n', '    function getMenu() constant returns (string, string, string, string, string)\n', '    {\n', '        return (shopSandwich[0].sandwichName, shopSandwich[1].sandwichName,\n', '                shopSandwich[2].sandwichName, shopSandwich[3].sandwichName,\n', '                shopSandwich[4].sandwichName );\n', '    }\n', '\n', '    function getSandwichInfoCaloriesPrice(uint _sandwich) constant returns (string, string, string, uint)\n', '    {\n', '        if( _sandwich > 4 )\n', '        {\n', '            return ( "wrong ID", "wrong ID", "zero", 0);\n', '        }\n', '        else\n', '        {\n', '            return (shopSandwich[_sandwich].sandwichName, shopSandwich[_sandwich].sandwichDesc,\n', '                shopSandwich[_sandwich].calories, shopSandwich[_sandwich].price);\n', '        }\n', '    }\n', '\n', '    function addToCart(uint _orderID, string _notes) returns (uint)\n', '    {\n', '        OrderedSandwich memory newOrder;\n', '        newOrder.sandID = _orderID;\n', '        newOrder.notes = _notes;\n', '        newOrder.price = shopSandwich[_orderID].price;\n', '\n', '        return cart[msg.sender].push(newOrder);\n', '    }\n', '\n', '    function getCartLength() constant returns (uint)\n', '    {\n', '        return cart[msg.sender].length;\n', '    }\n', '\n', '    function readFromCart(uint _spot) constant returns (string)\n', '    {\n', '        return cart[msg.sender][_spot].notes;\n', '    }\n', '\n', '    function emptyCart() public\n', '    {\n', '        delete cart[msg.sender];\n', '    }\n', '\n', '}']