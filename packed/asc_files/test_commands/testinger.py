from asc_fnc import asc_g_msg

def testinger(con=None, cData=None, args=()):
    """
    Send a msg back to the client (#3)
    - Multiple entries, with different types returned
    - "fnc" == Identifier for the Arma ExtensionCallback-Eventhandler
    - "data" == parameters given back
    - This functions triggers the function: "asc_fnc_example" on the receiving Client
    - Check the "ENTRY_GET" Macro to see, how to get all the entries of the data given
    """
    print('EXAMPLE FUNCTION "testinger" RECEIVED')

    data = {
            "string": "i am a string",
            "int": 0,
            "float": 0.1234,
            "array": ["array0", "array1"],
            "bool_false": False,
            "bool_true": True
        }

    asc_g_msg.sendMsg("ASC_example_return", data, con)
    print("SENDING AN ANSWER BACK TO THE CLIENT, WHICH SHOULD BE HANDLED BY THE CLIENT THEN")
    print("check your Arma3 .rpt to see the returned data")
