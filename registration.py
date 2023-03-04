import kivy
from kivy.app import App
from kivy.uix.label import Label
from kivy.uix.gridlayout import GridLayout
from kivy.uix.textinput import TextInput
from kivy.uix.button import Button

class PersonalDetailsPage(GridLayout):
    def __init__(self):
        super().__init__()

        self.cols = 2

        self.add_widget(Label(text = "First Name"))
        self.first_name = TextInput(multiline = False)
        self.add_widget(self.first_name)

        self.add_widget(Label(text = "Middle Name"))
        self.middle_name = TextInput(multiline = False)
        self.add_widget(self.middle_name)

        self.add_widget(Label(text = "Last Name"))
        self.last_name = TextInput(multiline = False)
        self.add_widget(self.last_name)

        self.next = Button(text = "Next")
        self.add_widget(self.next)


class RegistrationApp(App):
    def build(self):
        return PersonalDetailsPage()

if __name__ == "__main__":
    RegistrationApp().run()
