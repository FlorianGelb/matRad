function test_suite=test_mocks
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions=localfunctions();
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;

% Import der benötigten Funktionen
import matlab.mock.constraints.WasCalled.*
import matlab.mock.constraints.WasNotCalled.*

% Definition der Testfunktion
function testCalculate(mock)
    % Mock-Objekt erstellen
    dataMock = mock('get_data', 42);

    % Testfall 1: Überprüfen, ob die Funktion "get_data" aufgerufen wurde
    calculate(dataMock);
    assert(verifyThat(dataMock, WasCalled));

    % Testfall 2: Überprüfen, ob die Funktion "get_data" nicht aufgerufen wurde
    % wenn eine bestimmte Bedingung erfüllt ist
    calculate(dataMock, true);
    assert(verifyThat(dataMock, WasNotCalled));

% Funktion "get_data": gibt zufällige Daten zurück
function data = get_data()
    % Generieren Sie zufällige Daten
    data = rand(1, 10);

% Funktion "calculate": berechnet den Durchschnitt der Daten
function avg = calculate(data)
    % Berechnen Sie den Durchschnitt der Daten
    avg = mean(data, 'all');