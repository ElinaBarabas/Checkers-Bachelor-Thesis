from classifyChessFields import convert_matrix_to_fen, convert_chars
import unittest


class TestSmartBoardScanner(unittest.TestCase):

    def test_FEN_conversion(self):
        matrix = [['e', 'e', 'e', 'e', 'e', 'e', 'e', 'bb'],
                  ['e', 'e', 'e', 'e', 'bp', 'e', 'bk', 'e'],
                  ['e', 'wp', 'e', 'bp', 'e', 'e', 'e', 'e'],
                  ['e', 'e', 'e', 'e', 'e', 'e', 'e', 'e'],
                  ['e', 'e', 'e', 'e', 'e', 'e', 'e', 'e'],
                  ['e', 'wk', 'e', 'e', 'wp', 'e', 'e', 'e'],
                  ['e', 'e', 'e', 'e', 'e', 'e', 'e', 'e'],
                  ['e', 'e', 'e', 'e', 'e', 'e', 'e', 'e']]

        possible_fen = "7b/4p1k1/1P1p4/8/8/1K2P3/8/8 w KQkq - 0 1"

        result_matrix = convert_chars(matrix)
        resulted_string = convert_matrix_to_fen(result_matrix)

        self.assertTrue(possible_fen == resulted_string)

        possible_fen = "8/4p1k1/1P1p4/8/8/1K2P3/8/8 w KQkq - 0 1"
        self.assertFalse(possible_fen == resulted_string)


testClass = TestSmartBoardScanner()
testClass.test_FEN_conversion()
